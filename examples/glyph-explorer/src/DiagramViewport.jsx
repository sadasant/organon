import React, { useEffect, useId, useRef, useState } from "react";

export default function DiagramViewport({
  width,
  height,
  label,
  labelledBy,
  children,
}) {
  const id = useId();
  const svg = useRef(null);
  const frame = useRef(null);
  const gesture = useRef(null);
  const home = { x: width / 2, y: height / 2, zoom: 1 };
  const position = useRef(home);
  const [camera, setCamera] = useState(home);
  const [size, setSize] = useState({ width, height });
  const [pinned, setPinned] = useState(false);
  const [reducedMotion, setReducedMotion] = useState(false);
  const aspect = size.width / size.height;
  const fitWidth = Math.max(width, height * aspect);
  const fitHeight = fitWidth / aspect;
  // Enough magnification to read labels, without unbounded zoom or panning
  // into empty space. Geometry stays identical at every viewport size.
  const maxZoom = Math.min(8, Math.max(2, (fitWidth / size.width) * 1.25));
  const bound = (next) => {
    const zoom = Math.max(1, Math.min(maxZoom, next.zoom));
    const clamp = (value, extent, view) =>
      view >= extent
        ? extent / 2
        : Math.max(view / 2, Math.min(extent - view / 2, value));
    return {
      x: clamp(next.x, width, fitWidth / zoom),
      y: clamp(next.y, height, fitHeight / zoom),
      zoom,
    };
  };
  const draw = (next) => {
    position.current = next;
    setCamera(next);
  };
  const move = (next, animate = true) => {
    cancelAnimationFrame(frame.current);
    const target = bound(next);
    if (reducedMotion || !animate) return draw(target);
    const from = position.current;
    const start = performance.now();
    const tick = (now) => {
      const t = Math.min(1, (now - start) / 650);
      const eased = t * t * (3 - 2 * t);
      draw(
        bound({
          x: from.x + (target.x - from.x) * eased,
          y: from.y + (target.y - from.y) * eased,
          zoom: from.zoom * (target.zoom / from.zoom) ** eased,
        }),
      );
      if (t < 1) frame.current = requestAnimationFrame(tick);
    };
    frame.current = requestAnimationFrame(tick);
  };
  const reset = () => {
    gesture.current = null;
    setPinned(false);
    move(home);
  };
  const zoom = (factor) => {
    const next = bound({
      ...position.current,
      zoom: position.current.zoom * factor,
    });
    setPinned(next.zoom > 1);
    move(next);
  };

  useEffect(() => {
    const observer = new ResizeObserver(([entry]) => {
      cancelAnimationFrame(frame.current);
      gesture.current = null;
      setPinned(false);
      draw(home);
      setSize({
        width: entry.contentRect.width,
        height: entry.contentRect.height,
      });
    });
    observer.observe(svg.current);
    return () => {
      observer.disconnect();
      cancelAnimationFrame(frame.current);
    };
  }, [width, height]);
  useEffect(() => {
    const media = matchMedia("(prefers-reduced-motion: reduce)");
    const update = () => {
      setReducedMotion(media.matches);
      if (media.matches) {
        cancelAnimationFrame(frame.current);
        gesture.current = null;
        setPinned(false);
        draw(home);
      }
    };
    update();
    media.addEventListener("change", update);
    return () => media.removeEventListener("change", update);
  }, [width, height]);

  return (
    <div className="diagram-explorer">
      <div className="diagram-camera">
        <p aria-live="polite">
          {pinned
            ? "Drag to explore · tap to return"
            : "Tap to zoom · hold to peek"}
        </p>
        <div role="group" aria-label="Diagram camera">
          <button
            aria-label="Zoom out diagram"
            disabled={camera.zoom <= 1}
            onClick={() => zoom(1 / 1.5)}
          >
            −
          </button>
          <button onClick={reset}>Fit</button>
          <button
            aria-label="Zoom in diagram"
            disabled={camera.zoom >= maxZoom - 0.001}
            onClick={() => zoom(1.5)}
          >
            +
          </button>
        </div>
      </div>
      <p className="sr-only" id={`${id}-help`}>
        Tap or click an area to zoom in; tap again to return. Hold to peek and
        release to return. While zoomed, drag to pan. Keyboard: plus or minus to
        zoom, arrow keys to pan, Escape or Home to fit the whole diagram.
      </p>
      <div
        className="diagram-viewport"
        role="group"
        tabIndex={0}
        aria-label={`${label}: diagram navigation`}
        aria-describedby={`${id}-help`}
        onKeyDown={(event) => {
          const delta = {
            ArrowLeft: [-1, 0],
            ArrowRight: [1, 0],
            ArrowUp: [0, -1],
            ArrowDown: [0, 1],
          }[event.key];
          if (delta) {
            event.preventDefault();
            move({
              ...position.current,
              x:
                position.current.x +
                ((delta[0] * fitWidth) / position.current.zoom) * 0.15,
              y:
                position.current.y +
                ((delta[1] * fitHeight) / position.current.zoom) * 0.15,
            });
          } else if (["+", "=", "-", "Escape", "Home"].includes(event.key)) {
            event.preventDefault();
            if (["Escape", "Home"].includes(event.key)) reset();
            else zoom(event.key === "-" ? 1 / 1.5 : 1.5);
          }
        }}
      >
        <svg
          ref={svg}
          className={`specification-network${pinned ? " is-zoomed" : ""}`}
          style={{ aspectRatio: `${width} / ${height}` }}
          viewBox={`${camera.x - fitWidth / camera.zoom / 2} ${camera.y - fitHeight / camera.zoom / 2} ${fitWidth / camera.zoom} ${fitHeight / camera.zoom}`}
          role="img"
          aria-labelledby={labelledBy}
          onDragStart={(event) => event.preventDefault()}
          onContextMenu={(event) => event.preventDefault()}
          onPointerDown={(event) => {
            if (!event.isPrimary || event.button !== 0 || gesture.current)
              return;
            const point = svg.current.createSVGPoint();
            point.x = event.clientX;
            point.y = event.clientY;
            const focus = point.matrixTransform(
              svg.current.getScreenCTM().inverse(),
            );
            gesture.current = {
              id: event.pointerId,
              x: event.clientX,
              y: event.clientY,
              start: performance.now(),
              camera: position.current,
              pinned,
              moved: false,
            };
            event.currentTarget.setPointerCapture(event.pointerId);
            if (!pinned) move({ x: focus.x, y: focus.y, zoom: maxZoom });
          }}
          onPointerMove={(event) => {
            const start = gesture.current;
            if (!start || start.id !== event.pointerId) return;
            const dx = event.clientX - start.x,
              dy = event.clientY - start.y;
            if (Math.hypot(dx, dy) > 6) start.moved = true;
            if (start.pinned && start.moved) {
              const scale = fitWidth / size.width / start.camera.zoom;
              move(
                {
                  ...start.camera,
                  x: start.camera.x - dx * scale,
                  y: start.camera.y - dy * scale,
                },
                false,
              );
            }
          }}
          onPointerUp={(event) => {
            const start = gesture.current;
            if (!start || start.id !== event.pointerId) return;
            gesture.current = null;
            if (start.pinned) {
              if (!start.moved) reset();
            } else if (start.moved || performance.now() - start.start >= 300)
              reset();
            else setPinned(true);
          }}
          onPointerCancel={reset}
          onLostPointerCapture={() => {
            if (gesture.current) reset();
          }}
        >
          {children}
        </svg>
      </div>
    </div>
  );
}

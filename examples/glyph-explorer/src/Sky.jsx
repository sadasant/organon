import React, { useEffect, useRef } from "react";
import * as THREE from "three";

export default function Sky({ paused }) {
  const host = useRef(null);
  useEffect(() => {
    const target = host.current;
    let renderer;
    try {
      renderer = new THREE.WebGLRenderer({
        alpha: true,
        antialias: false,
        powerPreference: "low-power",
      });
    } catch {
      target.classList.add("static-stars");
      return;
    }
    renderer.setPixelRatio(Math.min(devicePixelRatio, 1.5));
    target.append(renderer.domElement);
    const geometry = new THREE.BufferGeometry();
    const count = 1000;
    const positions = new Float32Array(count * 3);
    const seeds = new Float32Array(count);
    let seed = 827;
    const random = () => {
      seed = (seed * 16807) % 2147483647;
      return seed / 2147483647;
    };
    for (let i = 0; i < count; i++) {
      positions[i * 3] = random() * 2 - 1;
      positions[i * 3 + 1] = random() * 2 - 1;
      seeds[i] = random();
    }
    geometry.setAttribute("position", new THREE.BufferAttribute(positions, 3));
    geometry.setAttribute("seed", new THREE.BufferAttribute(seeds, 1));
    const material = new THREE.ShaderMaterial({
      transparent: true,
      depthWrite: false,
      uniforms: {
        time: { value: 0 },
        ratio: { value: renderer.getPixelRatio() },
      },
      vertexShader: `attribute float seed; varying float vSeed; uniform float ratio;
        void main(){ vSeed=seed; gl_Position=vec4(position.xy,0.,1.); gl_PointSize=(1.+2.1*pow(seed,5.))*ratio; }`,
      fragmentShader: `varying float vSeed; uniform float time;
        void main(){ float d=length(gl_PointCoord-.5); float a=smoothstep(.5,.03,d);
        float shimmer=.7+.3*sin(time*.55+vSeed*90.);
        gl_FragColor=vec4(vec3(.85),a*(.16+.65*pow(vSeed,3.))*shimmer); }`,
    });
    const scene = new THREE.Scene();
    scene.add(new THREE.Points(geometry, material));
    const camera = new THREE.Camera();
    const reduced = matchMedia("(prefers-reduced-motion: reduce)");
    let frame = 0;
    let last = -Infinity;
    const draw = (time = 0) => {
      material.uniforms.time.value = time / 1000;
      renderer.render(scene, camera);
    };
    const loop = (time) => {
      if (time - last >= 50) {
        draw(time);
        last = time;
      }
      frame = requestAnimationFrame(loop);
    };
    const resume = () => {
      cancelAnimationFrame(frame);
      draw();
      if (!paused && !reduced.matches && !document.hidden)
        frame = requestAnimationFrame(loop);
    };
    const resize = () => {
      renderer.setSize(innerWidth, innerHeight);
      draw();
    };
    window.addEventListener("resize", resize);
    document.addEventListener("visibilitychange", resume);
    reduced.addEventListener("change", resume);
    resize();
    resume();
    return () => {
      cancelAnimationFrame(frame);
      window.removeEventListener("resize", resize);
      document.removeEventListener("visibilitychange", resume);
      reduced.removeEventListener("change", resume);
      geometry.dispose();
      material.dispose();
      renderer.dispose();
      renderer.domElement.remove();
    };
  }, [paused]);
  return <div ref={host} className="sky" aria-hidden="true" />;
}

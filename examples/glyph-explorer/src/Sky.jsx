import React, { useEffect, useRef } from "react";
import * as THREE from "three";

export default function Sky({ paused, density }) {
  const host = useRef(null);
  const elapsed = useRef(0);
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
      return () => target.classList.remove("static-stars");
    }
    renderer.setPixelRatio(Math.min(devicePixelRatio, 1.5));
    target.append(renderer.domElement);
    const geometry = new THREE.BufferGeometry();
    const count = Math.round(2200 * density);
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
      // A diffuse diagonal band among the scattered foreground stars.
      if (i % 3 === 0) {
        const scatter =
          Math.sqrt(-2 * Math.log(random())) * Math.cos(2 * Math.PI * random());
        positions[i * 3] = positions[i * 3 + 1] * 0.55 - 0.35 + scatter * 0.18;
      }
      positions[i * 3 + 2] = random();
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
      vertexShader: `attribute float seed; varying float vSeed;
        uniform float ratio;
        void main(){
          vSeed=seed;
          gl_Position=vec4(position.xy,0.,1.);
          gl_PointSize=(1.5+6.*pow(seed,9.))*ratio;
        }`,
      fragmentShader: `varying float vSeed; uniform float time;
        void main(){
          float d=length(gl_PointCoord-.5);
          float core=exp(-d*d*55.);
          float halo=exp(-d*d*13.)*.3;
          float shimmer=.78+.22*sin(time*(.32+vSeed*.35)+vSeed*90.);
          float a=(core+halo)*smoothstep(.5,.3,d);
          gl_FragColor=vec4(vec3(1.),a*(.4+.6*pow(vSeed,2.))*shimmer);
        }`,
    });
    const scene = new THREE.Scene();
    scene.add(new THREE.Points(geometry, material));
    const camera = new THREE.Camera();
    const reduced = matchMedia("(prefers-reduced-motion: reduce)");
    let frame = 0;
    let last = -Infinity;
    const draw = () => {
      material.uniforms.time.value = elapsed.current;
      renderer.render(scene, camera);
    };
    const loop = (time) => {
      if (time - last >= 50) {
        elapsed.current += Number.isFinite(last) ? (time - last) / 1000 : 0;
        draw();
        last = time;
      }
      frame = requestAnimationFrame(loop);
    };
    const resume = () => {
      cancelAnimationFrame(frame);
      last = -Infinity;
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
  }, [paused, density]);
  return (
    <div
      ref={host}
      className="sky"
      style={{ "--star-spacing": Math.sqrt(1 / density) }}
      aria-hidden="true"
    />
  );
}

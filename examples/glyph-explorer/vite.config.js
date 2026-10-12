import { defineConfig } from "vite";

export default defineConfig({
  base: "./",
  server: { port: 5173, strictPort: true, allowedHosts: [".onamp.dev"] },
  preview: { port: 5173, strictPort: true, allowedHosts: [".onamp.dev"] },
  build: {
    rollupOptions: {
      output: { manualChunks: { math: ["katex"], sky: ["three"] } },
    },
  },
});

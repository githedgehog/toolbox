// Copyright 2025 Hedgehog
// SPDX-License-Identifier: Apache-2.0

package main

import (
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"go.githedgehog.com/toolbox/pkg/version"
)

func main() {
	fmt.Println("Demo server", version.Version)

	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/plain; charset=utf-8")
		w.Header().Set("Cache-Control", "no-cache")
		w.Header().Set("Connection", "keep-alive")

		if f, ok := w.(http.Flusher); ok {
			for {
				_, _ = w.Write([]byte(fmt.Sprintf("Request from %s to %s\n", r.Host, r.RemoteAddr)))
				f.Flush()

				time.Sleep(1 * time.Second)
			}
		} else {
			http.Error(w, "Streaming not supported", http.StatusInternalServerError)
		}
	})

	srv := &http.Server{
		Addr:              ":3000",
		ReadHeaderTimeout: 10 * time.Second,
		ReadTimeout:       30 * time.Second,
		WriteTimeout:      900 * time.Second,
		IdleTimeout:       90 * time.Second,
		Handler:           r,
	}
	if err := srv.ListenAndServe(); err != nil {
		fmt.Println("Error starting server:", err)
		os.Exit(1)
	}
}

package logger

import (
	"os"
	"strings"

	"github.com/rs/zerolog"
)

func New(level, format string) zerolog.Logger {
	// Parse log level
	logLevel, err := zerolog.ParseLevel(strings.ToLower(level))
	if err != nil {
		logLevel = zerolog.InfoLevel
	}

	zerolog.SetGlobalLevel(logLevel)

	// Configure output format
	var log zerolog.Logger
	if format == "pretty" || format == "console" {
		log = zerolog.New(zerolog.ConsoleWriter{Out: os.Stdout}).
			With().
			Timestamp().
			Caller().
			Logger()
	} else {
		log = zerolog.New(os.Stdout).
			With().
			Timestamp().
			Caller().
			Logger()
	}

	return log
}

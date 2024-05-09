package configs

import (
	"fmt"
	"log"
	"strconv"

	"github.com/joho/godotenv"
)

func LoadConfigs(path string) IConfig {
	env, err := godotenv.Read(path)
	if err != nil {
		log.Fatalf("Error loading .env file: %v", err)
	}

	return &config{
		db: &db{
			host:     env["DB_HOST"],
			dbname:   env["DB_NAME"],
			port:     func() int { port, _ := strconv.Atoi(env["DB_PORT"]); return port }(),
			user:     env["DB_USERNAME"],
			password: env["DB_PASSWORD"],
		},
		jwt: &jwt{
			secretKey: []byte(env["JWT_SECRET_KEY"]),
		},
	}
}

type IConfig interface {
	Db() IDbConfig
	Jwt() IJwtConfig
}

type config struct {
	db  *db
	jwt *jwt
}

type IDbConfig interface {
	Url() string
}

type db struct {
	host     string
	dbname   string
	port     int
	user     string
	password string
}

func (c *config) Db() IDbConfig {
	return c.db
}

func (d *db) Url() string {
	return fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%d sslmode=disable",
		d.host,
		d.user,
		d.password,
		d.dbname,
		d.port)
}

type IJwtConfig interface {
	SecretKey() []byte
}

type jwt struct {
	secretKey []byte
}

func (c *config) Jwt() IJwtConfig {
	return c.jwt
}

func (j *jwt) SecretKey() []byte {
	return j.secretKey
}

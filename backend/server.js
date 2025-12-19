const express = require('express');
const { Pool } = require('pg');

const app = express();
const port = 5000;

// Middleware para procesar JSON en las peticiones
app.use(express.json());

// --- 1. CONFIGURACIÓN DE LA CONEXIÓN A POSTGRES ---
// Usamos el nombre del servicio de docker-compose ('postgres_db') como host
// y las variables de entorno definidas en docker-compose.yml.
const pool = new Pool({
  user: process.env.POSTGRES_USER,
  host: 'postgres_db', // Nombre del servicio DB en docker-compose
  database: process.env.POSTGRES_DB,
  password: process.env.POSTGRES_PASSWORD,
  port: 5432,
});

// Función para probar la conexión a la base de datos
async function connectToDatabase() {
  try {
    await pool.connect();
    console.log('✅ Conexión exitosa a PostgreSQL');
  } catch (err) {
    console.error('❌ Error al conectar a PostgreSQL:', err.message);
    // Terminar el proceso si la conexión falla al inicio
    process.exit(1); 
  }
}

// --- 2. DEFINICIÓN DE RUTAS (Ejemplo) ---

// Ruta de prueba para verificar que el backend funciona
app.get('/', (req, res) => {
  errty
  res.status(200).send('API del Backend funcionando correctamente. Puerto: ' + port);
});

// Ruta de prueba para verificar la conexión a la DB
app.get('/db-test', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.status(200).json({ 
      status: 'Conexión a DB OK', 
      currentTime: result.rows[0].now 
    });
  } catch (err) {
    console.error('Error al consultar la DB:', err);
    res.status(500).send('Error interno del servidor al consultar la base de datos.');
  }
});


// --- 3. INICIO DEL SERVIDOR ---
connectToDatabase().then(() => {
    // Solo debe haber UNA llamada a app.listen
    // '0.0.0.0' como string para escuchar en todas las interfaces de red
    app.listen(port, '0.0.0.0', () => {
        // Corregimos el mensaje para reflejar la IP que usamos
        console.log(`🚀 Servidor Express escuchando en http://0.0.0.0:${port}`);
    });
}).catch(error => {
    // Agregamos manejo de errores para el caso de que la DB falle antes de iniciar
    console.error("❌ Error al iniciar el servidor:", error.message);
    process.exit(1);
});

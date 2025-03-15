const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
const port = 3000;

const corsOptions = {
  origin: '*',
  methods: ['GET'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true,
  optionsSuccessStatus: 200
};

app.use(cors(corsOptions));

const phrases = [
    "Gracias a Barkibu, Max superó una cirugía complicada sin preocupaciones económicas.",
    "Cuando Luna necesitó tratamiento para su piel, Barkibu cubrió casi todo. ¡Hoy está mejor que nunca!",
    "Bruno sufrió una fractura jugando, pero con la ayuda de Barkibu, su recuperación fue rápida y accesible.",
    "Barkibu ayudó a Rocky a recibir el tratamiento adecuado para su problema respiratorio, sin romper el banco.",
    "¡La cirugía dental de Bella fue todo un éxito, y su dueño apenas tuvo que pagar gracias a Barkibu!",
    "Cuando Toby tuvo una infección, Barkibu cubrió los costosos antibióticos y hoy está saludable de nuevo.",
    "Gracias a Barkibu, Nala pudo someterse a una operación de emergencia que salvó su vida.",
    "Rex sufrió una enfermedad intestinal, pero con Barkibu su tratamiento fue asequible y efectivo.",
    "La intervención que necesitaba Coco fue totalmente cubierta por Barkibu. ¡Ahora está más fuerte que nunca!",
    "Barkibu ayudó a Molly a superar una enfermedad crónica, permitiendo a su dueño centrarse en su bienestar, no en los costos.",
    "Cuando Simba tuvo un accidente, Barkibu cubrió las radiografías y tratamientos, ¡hoy está corriendo de nuevo!",
    "Con la ayuda de Barkibu, Daisy recibió atención preventiva que evitó problemas de salud mayores.",
    "Max tuvo un diagnóstico grave, pero Barkibu cubrió las consultas con especialistas. ¡Ahora está mejor!",
    "La alergia de Buster fue tratada rápidamente gracias a Barkibu, sin agotar los ahorros de su dueño.",
    "La operación de emergencia de Charlie fue cubierta casi en su totalidad por Barkibu. ¡Hoy disfruta de una vida plena!",
    "Con Barkibu, Sparky pudo recibir un tratamiento costoso para su artritis, mejorando su calidad de vida.",
    "Cuando Luna necesitó fisioterapia, Barkibu la cubrió, ¡y ahora corre como si nada hubiera pasado!",
    "El tratamiento para la diabetes de Max fue costoso, pero Barkibu hizo que fuera accesible y continuo.",
    "Barkibu ayudó a Bruno a superar una infección grave sin preocupaciones económicas para su dueño.",
    "Con la ayuda de Barkibu, Bella pudo recibir atención avanzada para su problema renal sin generar deudas a su dueño."
  ];

  const hashtags = ['#cute', '#CuteDog', '#doggo', '#puppy', '#fluffy', '#adorable', '#pet', '#love', '#happy', '#BestFriend', '#PuppyLove', '#DogsOfInstagram', '#DogLover'];

app.get('/post', async (req, res) => {
    try {      
      const response = await axios.get('https://random.dog/woof.json');
        
      const { url } = response.data;        
      const randomMessage = phrases[Math.floor(Math.random() * phrases.length)];      
      const randomHashtags = hashtags.sort(() => 0.5 - Math.random()).slice(0, 2);

      res.json({
        message: randomMessage,
        imageUrl: url,
        hashtags: randomHashtags
      });
    } catch (error) {      
      res.status(500).json({ message: "Error while trying to create the image", error: error.message });
    }
  });
  
  app.listen(port, () => {
    console.log(`Server running: http://localhost:${port}`);
  });

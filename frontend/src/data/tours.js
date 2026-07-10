import chofer1 from "../assets/cristochofer.jpg";
import chofer2 from "../assets/andresfeliz.png";
import chofer3 from "../assets/pibechofertraductorchino.png";
const tours = [
  {
    id: 1,
    title: "Ruta Puerto Montt → Puerto Varas",
    from: "Puerto Montt",
    to: "Puerto Varas",
    duration: "45 minutos",
    price: 12000,
    image: chofer1,
  },
  {
    id: 2,
    title: "Ruta Puerto Montt → Castro",
    from: "Puerto Montt",
    to: "Castro",
    duration: "3 horas",
    price: 25000,
    image: chofer2,
  },
  {
    id: 3,
    title: "Ruta Puerto Varas → Frutillar",
    from: "Puerto Varas",
    to: "Frutillar",
    duration: "30 minutos",
    price: 9000,
    image: chofer3,
  },
];

export default tours;

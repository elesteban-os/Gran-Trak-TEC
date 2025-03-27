from PIL import Image
import numpy as np

def image_to_matrix(image_path):
    # Cargar la imagen en modo de escala de grises
    img = Image.open(image_path).convert('L')
    
    # Convertir la imagen a una matriz de numpy
    img_array = np.array(img)
    
    # Crear una matriz binaria (0 para negro, 1 para blanco)
    binary_matrix = np.where(img_array > 127, 1, 0)
    
    return binary_matrix

def print_matrix(matrix):
    for row in matrix:
        print("db ", ", ".join(map(str, row)))

# Ejemplo de uso
image_path = "circuitcreator/imagen.png"  # Reemplaza con la ruta de tu imagen
matrix = image_to_matrix(image_path)
print_matrix(matrix)

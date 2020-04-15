#version 3.7;
global_settings { assumed_gamma 1.2 } 

#include "metals.inc"
#include "glass.inc"     
 
#declare niebo = sky_sphere 
{
    pigment 
    {
        gradient y
        color_map 
        {
            [0.0 rgb <0.5, 0.6, 1.0>]                 //okreœlenie koloru (sk³adowe r-czerwony,g-zielony,b-niebieski)
            [0.7 rgb <0.1, 0.2, 0.8>]
        }
    }
}
              
#declare swiatlo = light_source               // wstawienie œwiat³a punktowego
{
    <0, 0, 0>                 // pozycja pocz¹tkowa œwiat³a
    color rgb <1, 1, 1>       // kolor œwiat³a
    translate <0, 300, -300>  // przemieszczenie x,y,z
}
 
#declare podloga = plane                      // pod³oga w "szachownicê"
{
    y, 0
    texture
    {
        pigment 
        {
            checker
            color rgb <0.6, 0.6, 0.6>
            color rgb <1, 0.3, 0>
            scale 0.5
        }
        finish
        {
            diffuse 0.8
            ambient 0.1
        }
    }
}
                 
#declare podloze = union
{
    object{swiatlo}
    object{podloga}
}                                 

#declare szklo = material 
{
    texture 
    {
        pigment 
        { 
            color rgbf <0.98, 1.0, 0.99, 0.92> 
        }
        finish 
        { 
            F_Glass1 
        }
    }
    interior {I_Glass caustics 1}
}
       
#declare metal = material 
{  
    texture
    {
        pigment
        {
            color rgb <0.20, 0.20, 0.25> 
        }
        finish 
        {
            ambient 0.2 
            brilliance 6      
            diffuse 1.8
            metallic
            specular 11
            roughness 1/17
            reflection 0.01
        }
    }
}                    

#declare podpora_mat = material
{
    texture
    {    
        pigment 
        {
            color rgb <0.1, 0.1, 0.1>
            scale 0.5
        }
        finish
        {
            diffuse 0.2
            ambient 0.1         
            brilliance 2
        }
    }
}      

sky_sphere{niebo}                                     
object{podloze}      

camera 
{
    location  <1.5, 3.0, -7>                  // punkt, w którym znajduje siê kamera
    look_at   <1.5, 2.0,  0.0>                  // punkt, na który skierowana jest kamera
}  
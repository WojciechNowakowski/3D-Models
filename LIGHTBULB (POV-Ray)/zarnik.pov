#version 3.7;
global_settings { assumed_gamma 1.0 } 
                      
#ifndef (application)                      // testowanie                       
    #include "scena.pov"       
#end    
          
#declare srednica = 1.6;          
#declare skala = 0.2;      
#declare zwoje1 = 60;                            
#declare wsp_z = 8.5 / zwoje1;  
          
#declare stala_0 = 0;          
#declare stala_1 = 1;      
                         
#ifndef (show_light)
    #declare show_light = 0;
#end

#if (show_light)   
    #declare gestosc = 6.28;
#else             
    #declare gestosc = 0.08;   
#end

#declare poz1_x = 0;
#declare poz1_y = 0;
#declare poz1_z = 0;
#declare poz2_x = 0;
#declare poz2_y = 0;
#declare poz2_z = 0;
#declare poz3_x = 0;
#declare poz3_y = 0;
#declare poz3_z = wsp_z * zwoje1 * 2 * pi * skala;

   
#declare punkt_swiatla = sphere
{    
    0, 0.08
    texture
    {
        pigment
        {
            color rgb <1, 0.5, 0.15> 
        }
        finish 
        {
            ambient 0.2 
            diffuse 0.8
        }
    } 
}   
   
#declare punkt_zarnika = sphere  
{
    <0, 0, 0>,      
    #if (show_light)     
        4.6
        pigment { rgbt 1 } hollow
        interior
        { 
            media
            { 
                emission 1
                density
                { 
                    spherical density_map
                    { 
                        [1 rgb <1,0.7,0.3>] //<1,0.4,0>]
                    }
                }
            }
        }      
    #else   
        0.08          
        texture
        {    
            pigment 
            {
                color rgb <0.1, 0.1, 0.1>
                scale 0.5
            }
            finish
            {
                diffuse 0.8
                ambient 0.3         
                brilliance 2
            }
        }  
    #end
}                 

#declare szklo1 = cylinder
{
    <4.5, -8.80, zwoje1*pi*wsp_z*skala>,
    <4.5, -14.80, zwoje1*pi*wsp_z*skala>, 2.6     
    material{szklo} 
}

#declare szklo2 = sphere
{
    <4.5, -8.80, zwoje1*pi*wsp_z*skala>, 2.6
    material{szklo} 
}     

#declare szklo3 = sphere
{
    <4.5, -18.80, poz3_z/2>, 5
    material{szklo}       
} 

#declare szklo4 = cylinder
{
    <4.5, -18.80, poz3_z/2>,
    <4.5, -26.80, poz3_z/2>, 5     
    material{szklo}
}    
     

#declare podpora_zarnika1 = cylinder
{
    <4.5, -8.80, zwoje1*pi*wsp_z*skala-1.5>, <0, 0, 0>, 0.05   
    material{podpora_mat}
} 

#declare podpora_zarnika2 = cylinder
{
    <4.5, -8.80, zwoje1*pi*wsp_z*skala+1.5>, <0, 0, zwoje1*2*pi*wsp_z*skala>, 0.05   
    material{podpora_mat}    
}      

#declare podpora_zarnika3 = cylinder
{
    <5.0, -11.80, poz3_z/2 - 1.5>, <poz3_z/sqrt(2), 0, -poz3_z/sqrt(2)>, 0.18
    material{podpora_mat}    
}

#declare podpora_zarnika4 = cylinder
{
    <5.0, -11.80, poz3_z/2 + 1.5>, <poz3_z/sqrt(2), 0, poz3_z + poz3_z/sqrt(2)>, 0.18
    material{podpora_mat}    
}                             

#declare fragment = union
{              
    #for (i,0,zwoje1*2*pi,gestosc)
        object 
        {                                             
            punkt_zarnika   
            translate <srednica * cos(i), srednica * sin(i), wsp_z *i> 
            scale skala
        }
    #end  
}                     
                   
#declare koleczko = union
{        
    torus
    {        
        0.5, 0.08    
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
    rotate <0, 0, 90>  
}                    
                   

#declare zarnik = union
{                           
    merge
    {
        object{szklo1}         
        object{szklo2}   
        object{szklo3}         
        object{szklo4} 
    }          
    cylinder
    {
        <5.0, -11.80, poz3_z/2 + 1.5>, <5.0, -26.80, poz3_z/2 + 1.5>, 0.18
    }
    cylinder
    {       
        <5.0, -11.80, poz3_z/2 - 1.5>, <5.0, -26.80, poz3_z/2 - 1.5>, 0.18
    }
    object{podpora_zarnika1}
    object
    {
        koleczko                   
        rotate <0, 90, 0>
        translate <0.4, 0, 0>   
    }     
    object{podpora_zarnika2}   
    object
    {
        koleczko                  
        rotate <0, 90, 0>
        translate <0.4, 0, 0>
        translate <0, 0, poz3_z> 
    }   
    object{podpora_zarnika3}  
    object
    {
        koleczko        
        translate <0, 0, 0.4>  
        translate <poz3_z/sqrt(2), 0, -poz3_z/sqrt(2)>
    }    
    object{podpora_zarnika4}    
    object
    {
        koleczko       
        translate <0, 0, -0.4> 
        translate <poz3_z/sqrt(2), 0, poz3_z + poz3_z/sqrt(2)>
    }
    object
    {
        fragment    
        rotate <0, 135, 0>  
        translate <poz1_x, poz1_y, poz1_z>
    }   
    object
    {
        fragment          
        translate <poz2_x, poz2_y, poz2_z>
    }                                       
    object
    {
        fragment    
        rotate <0, 45, 0>  
        translate <poz3_x, poz3_y, poz3_z>
    }      
    #if (show_light)
        #for (i,0,zwoje1*2*pi,100)
            light_source 
            {
                <0,0,0>
                color rgb <1 1 1>  
                fade_distance 5
                fade_power 1 
                translate <srednica * cos(i), srednica * sin(i), wsp_z *i>    
                //looks_like{punkt_swiatla}
                scale skala  
                rotate <0, 135, 0>  
                translate <poz1_x, poz1_y-0.1, poz1_z>
            }                         
        #end  
        #for (i,0,zwoje1*pi*2,100)           //0,zwoje1*2*pi,gestosc*80)
            light_source 
            {
                <0,0,0>
                color rgb <1 1 1>  
                fade_distance 5
                fade_power 1 
                translate <srednica * cos(i), srednica * sin(i), wsp_z *i>    
                //looks_like{punkt_swiatla}
                scale skala 
                translate <poz2_x, poz2_y-0.1, poz2_z>
            }                         
        #end 
        #for (i,0,zwoje1*2*pi,100)
            light_source 
            {
                <0,0,0>
                color rgb <1 1 1>  
                fade_distance 2
                fade_power 1 
                translate <srednica * cos(i), srednica * sin(i), wsp_z *i>    
                //looks_like{punkt_swiatla}
                scale skala       
                rotate <0, 45, 0>  
                translate <poz3_x, poz3_y-0.1, poz3_z>
            }                         
        #end      
    #end 
}                                             


#ifndef (application)                      // testowanie     
    camera 
    {
        location  <0.0, 2, -5>                  // punkt, w którym znajduje siê kamera
        look_at   <0.0, 1.5,  0.0>                  // punkt, na który skierowana jest kamera
    }        
    sky_sphere{niebo} 
    object{podloze}         
    object
    {
        zarnik           
        translate <-4.5, 26.80, -poz3_z/2>      // aby œrodek ¿arnika znajdowa³ siê w <0, 0, 0>
        scale <0.075, 0.12, 0.075>//0.1   
        rotate <0, 90, 0>                        
    }
#end
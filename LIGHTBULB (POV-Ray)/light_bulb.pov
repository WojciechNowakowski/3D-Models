#version 3.7;
global_settings { assumed_gamma 1.2 } 
                                         
#declare application = 1;                                         

#include "scena.pov"     
#include "zarnik.pov"

#declare grub_szkla = 0.04;       
#declare dokladnosc_gwintu = 0.003;  // docelowo 0.003       
#declare render_zarnik = 1;            
#declare nic = 0.000000001;
          
#declare sfera = difference
{        
    sphere
    {
        <0, 3.2, 0>, 2
    }
    sphere
    {
        <0, 3.2, 0>, 2-grub_szkla
    }                    
}

#declare polsfera = difference
{
    object{sfera}
    cylinder
    {
        <0, 2.4, 0>, <0, 1.1, 0>, 2
    }      
    material{szklo}   
}           
  
#declare stozek_pusty = difference
{                                 
    cone
    {
        <0, 2.4, 0>, sqrt(4-0.8*0.8), <0, 0.8 0>, 1.1  
    }
    cone
    {
        <0, 2.4+nic, 0>, sqrt(4-0.8*0.8)-grub_szkla, <0, 0.8-nic, 0>, 1.1-grub_szkla
    }                     
    material{szklo}
}  

#declare cylinderek = difference
{
    cylinder
    {            
        <0, 0.8, 0>, <0, 0.4, 0>, 1.1
    }
    cylinder
    { 
        <0, 0.8+nic, 0>, <0, 0.4-nic, 0>, 1.1-grub_szkla
    }
    material{szklo}  
}
  
#declare trzon = difference
{                          
    cone
    {
        <0, 0.4, 0>, 1.1, <0, 0, 0>, 0.85   
    }      
    cone
    {
        <0, 0.4+nic, 0>, 1.1-grub_szkla, <0, 0-nic, 0>, 0.85-grub_szkla 
    }                       
    material{szklo} 
}                     

#declare metalowe_1 = cylinder
{
    <0, 0.0, 0>, <0, -0.3, 0>, 0.85
    material{metal}
}     

#declare metalowe_2 = cylinder              // na tym bêdzie gwint
{
    <0, -0.3, 0>, <0, -1.3, 0>, 0.8
    material{metal}
} 

#declare metalowe_3 = cone
{
    <0, -1.3, 0>, 0.85, <0, -1.6, 0>, 0.65 
    material{metal}
}
 
#declare czarne = cone
{
    <0, -1.6, 0>, 0.6, <0, -1.9, 0>, 0.35 
} 

#declare koncowka = sphere
{
    <0, -1.7, 0>, 0.4
    texture
    {
        T_Chrome_1A
    }                  
    scale <1.0, 0.90, 1.0>   
    translate <0.0, -0.1, 0.0>
}  

#declare p_d_z_x = 0;       // punkt dolny ¿arówki x
#declare p_d_z_y = -1.9;    // punkt dolny ¿arówki y
#declare p_d_z_z = 0;       // punkt dolny ¿arówki z
                     
                                          
#declare ilosc_zwoi = 3.2;  
#declare kat = ilosc_zwoi * 2 * pi;  // k¹t zataczany przez gwint  
#declare start_y = -0.3;
#declare end_y = -1.3;
#declare fi_g = 0.8;      
#declare fi_pg_const = 0.1;                 
#declare gwint = union
{                         
    #for (i, dokladnosc_gwintu, kat, dokladnosc_gwintu+0.00)        
        #declare trans_y = (end_y - start_y) * i / kat;
        #if (trans_y > -fi_pg_const/2) 
            #declare fi_pg = trans_y;
            #declare scale_y = 2*trans_y / fi_pg_const;
        #elseif (trans_y < (end_y - start_y) + fi_pg_const/2)
            #declare fi_pg = trans_y - (end_y - start_y);
            #declare scale_y = 2*(trans_y - (end_y - start_y)) / fi_pg_const;
        #else
            #declare fi_pg = fi_pg_const;
            #declare scale_y = 1;
        #end
        object 
        {                                             
            sphere
            {
                <0, 0, 0>, fi_pg_const//fi_pg
                material{metal}
                scale<1, scale_y * 0.9, 1>
            }                     
            translate <0, start_y, 0>  
            translate <-fi_g * cos(i), trans_y/*(end_y - start_y) * i / kat*/, fi_g * sin(i)> 
        }
    #end
}
  
#declare banka = merge
{                        
    object{polsfera}              
    object{stozek_pusty}   
    object{cylinderek}     
    object{trzon}           
}         

#declare obudowa = union
{                         
    object{banka}
    object{metalowe_1}     
    object{metalowe_2}
    object{metalowe_3}  
    object{czarne}     
    object{koncowka}
    object{gwint}
}                         

#declare zarowka = union
{                 
    object{obudowa}
    #if (render_zarnik)
        object
        {
            zarnik           
            translate <-4.5, 26.80, -poz3_z/2>      // aby œrodek ¿arnika znajdowa³ siê w <0, 0, 0>
            scale <0.07, 0.12, 0.07>//0.1   
            rotate <0, 60, 0>                        
        }
    #end
}                                           
       
object
{
    zarowka          
    rotate <90, 0, 0> 
    rotate <0, 90, 0>   
    rotate <135 + 360 * clock, 0, 0>
    translate <0, 3.0, 0>   
}

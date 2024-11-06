//
//  AudiosPreguntasModuloViewController.swift
//  Mi-Guia
//
//  Created by Mariano Rodriguez Abarca on 06/01/24.
//  Copyright © 2024 Mariano Rodriguez Abarca. All rights reserved.
//
import UIKit
import SwiftUI
import AVFoundation

class AudiosPreguntasModuloViewController: UIViewController {
    
    var materia:String?
    var numPreguntas:String?
    var ayuda:String?
    var arrayPreguntas:[[String:String]] = []
    var arrayRespuestas:[String] = []
    var contador:Int=0
    var totalPreguntasInt:Int=0
    var tooltipVar:String=""
    var preguntaPrincVar:String=""
    var imagenTooltip:String = ""
    var tooltip:String = ""
    var respueta:String = ""
    var imagenPreguntaMain:String = ""
    var prueba:Int=0
    var correcta:String = ""
    var contadorCorrectas:Int = 0
    var imagenSiNo:Bool = false
    var audioPregunta:String = ""
    var audioTooltip:String = ""
    var soloCierra = "No"
    var tamanoPantallaXTooltipp: CGFloat!
    var tamanoPantallaYTooltipp: CGFloat!
    var tamanoPantallaYTooltippAcomoda: CGFloat!
    var scrollView: UIScrollView!
    var modoJuego:String = "Si"
    var nombreMateria:String = ""
    var idMateria:String=""
    var tipoJuego:String=""
    
    @IBAction func playTooltip(_ sender: Any) {
        let urlFile = "https://pypsolucionesintegrales.com/Imagenes"+audioTooltip
        let url = NSURL(string: urlFile)
        play(url: url!)
    }
    
    @IBAction func stopTooltip(_ sender: Any) {
        let urlFile = "https://pypsolucionesintegrales.com/Imagenes"+audioPregunta
        let url = NSURL(string: urlFile)
        playStop(url: url!)
    }
    
    
    @IBAction func siguientePregunta(_ sender: Any) {
        soloCierra = "No"
 
        if(totalPreguntasInt == contador){
            self.performSegue(withIdentifier: "vermoduloRepaso", sender: self)
        }else{
            contador = contador + 1
            pregunta() 
        }
    }
    
    
    @IBAction func saltaRepaso(_ sender: Any) {
        
 
        modoJuego = "No"
        print("modoJuego: \(modoJuego)")
        
        if(modoJuego=="Si"){
            if(tipoJuego=="Skyinvaders"){
                performSegue(withIdentifier: "verModuloJuego", sender: sender)
            }
            if(tipoJuego=="Crucigrama"){
                performSegue(withIdentifier: "crucigrama", sender: sender)
            }
            
        }else{
            performSegue(withIdentifier: "vermoduloRepaso", sender: sender)
        }
        
    }
    
    @IBOutlet weak var pregImageInstrucciones: UITextView!
    
    
    @IBOutlet weak var preguntaMainPincipal: UITextView!
    
    
    @IBOutlet weak var scrollPreguntas: UIScrollView!
    
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tamanoPantallaXTooltipp = self.view.frame.size.width
        tamanoPantallaYTooltipp = self.view.frame.size.height
        tamanoPantallaYTooltippAcomoda = 60.0
        
        totalPreguntasInt = (numPreguntas! as NSString).integerValue - 1
        
       /* scrollView = UIScrollView(frame: CGRect(x: 0, y: tamanoPantallaYTooltippAcomoda, width: tamanoPantallaXTooltipp, height: tamanoPantallaYTooltipp))
        scrollView.contentSize = CGSize(width: tamanoPantallaXTooltipp, height: 3000)*/
 
        
        UINavigationBar.appearance().barTintColor = UIColor(red:0.84, green:0.62, blue:0.06, alpha:1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)]
        
        print("materia: \(materia!)")
        print("numPreguntas: \(numPreguntas!)")
        print("ayuda: \(ayuda!)")
        // Do any additional setup after loading the view.
 
        print("arrayPreguntas: \(arrayPreguntas)")
 
       /* self.addCuestions()
        DispatchQueue.main.async {
            
            do {
                
                
                self.pregunta()
                
                OperationQueue.main.addOperation {
                    self.boxView.removeFromSuperview()
                }
            } catch {
                print("error in Concurrent Queue)")
            }
        }*/
 
        pregImageInstrucciones.isScrollEnabled = true
        preguntaMainPincipal.isScrollEnabled = true
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pregunta()
        
    }
    
    func play(url:NSURL) {
        print("playing \(url)")

        do {
            let playerItem = AVPlayerItem(url: url as URL)
            self.player = try AVPlayer(playerItem:playerItem)
            player.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    func playStop(url:NSURL) {
        print("playing \(url)")

        do {
            let playerItem = AVPlayerItem(url: url as URL)
            self.player = try AVPlayer(playerItem:playerItem)
            player.pause()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    
    func playSound(nombreMp3: String) {
        print("nombreMp3Play: \(nombreMp3)")
    //https://pypsolucionesintegrales.com/Imagenes/
        let urlFile = "https://pypsolucionesintegrales.com/Imagenes"+nombreMp3
        print(urlFile)
        //let path = Bundle.main.resourcePath!+nombreMp3
        //print(path)
        
                let url = URL(fileURLWithPath: urlFile)

                let playerItem = AVPlayerItem(url: url)
                player = AVPlayer(playerItem: playerItem)
                player.play()
    }
    
    func stopSound(nombreMp3: String) {
        print("nombreMp3Stop: \(nombreMp3)")
        let path = Bundle.main.resourcePath!+nombreMp3
                print(path)
                let url = URL(fileURLWithPath: path)

                let playerItem = AVPlayerItem(url: url)
                player = AVPlayer(playerItem: playerItem)
                player.pause()
    }
    
    // Create the Activity Indicator
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var boxView = UIView()
    
    func addCuestions() {
        // You only need to adjust this frame to move it anywhere you want
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.white
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = "Cargando..."
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
    }
    

    
    func adjustUITextViewHeight(arg: UITextView) {
        arg.isScrollEnabled = true
        arg.textAlignment = .justified
        arg.isSelectable = false
        
        // Habilitamos el desplazamiento vertical
        arg.setContentOffset(.zero, animated: false)

        // Ajustamos la altura del UITextView según el contenido
        let fixedWidth = arg.frame.size.width
        let newSize = arg.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        arg.frame.size = CGSize(width: fixedWidth, height: newSize.height)
    }

    
    func pregunta(){
        //     for i in 0  ..< arrayPreguntas.count  {
        //    print("i: \(i)")
        
        tamanoPantallaYTooltippAcomoda = 50.0
        
        respueta = ""
        
        tooltip = arrayPreguntas[contador]["tooltip"]!
        correcta = arrayPreguntas[contador]["correcta"]!
        imagenTooltip = arrayPreguntas[contador]["imagentooltip"]!
        audioPregunta = "/"+arrayPreguntas[contador]["audiopregunta"]!
        audioTooltip = "/"+arrayPreguntas[contador]["audiotooltip"]!
        
        print("audioPregunta: \(audioPregunta)")
        print("audioTooltip: \(audioTooltip)")
        
        arrayPreguntas[contador]["pregunta"]!.trimmingCharacters(in: .whitespaces)
        
        print("Pregunta: \(arrayPreguntas[contador]["pregunta"]!.trimmingCharacters(in: .whitespaces))")
        
       // preguntaMainPincipal.text = ""
       // pregImageInstrucciones.text = ""
        
       // preguntaMainPincipal.adjustsFontForContentSizeCategory = false
       // pregImageInstrucciones.adjustsFontForContentSizeCategory = false
        
        preguntaMainPincipal.isScrollEnabled = false
        pregImageInstrucciones.isScrollEnabled = false
        
        self.preguntaMainPincipal.font = .systemFont(ofSize: 16)
        self.pregImageInstrucciones.font = .systemFont(ofSize: 16)
        
        if(arrayPreguntas[contador]["imagentooltip"]! == ""){
            
         preguntaMainPincipal.frame = CGRect(x: 10.0, y: tamanoPantallaYTooltippAcomoda, width: tamanoPantallaXTooltipp - 20.0 , height: tamanoPantallaYTooltipp)
            
            imagenSiNo = false
            preguntaMainPincipal.text = arrayPreguntas[contador]["tooltip"]!.trimmingCharacters(in: .whitespaces)
            pregImageInstrucciones.text = ""
            
            preguntaMainPincipal.isScrollEnabled = false
            
            preguntaMainPincipal.translatesAutoresizingMaskIntoConstraints = true
            preguntaMainPincipal.sizeToFit()
            preguntaMainPincipal.isEditable = false
            preguntaMainPincipal.isSelectable = false
            
            let fixedWidth = preguntaMainPincipal.frame.size.width
            
            let newSize = preguntaMainPincipal.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            
            preguntaMainPincipal.frame.size = CGSize(width: tamanoPantallaXTooltipp - 10.0, height: newSize.height)
            
            scrollPreguntas.addSubview(preguntaMainPincipal)
            
            scrollPreguntas.contentSize = CGSize(width: tamanoPantallaXTooltipp, height: tamanoPantallaYTooltippAcomoda)

            
            //self.view.addSubview(scrollView)
            
            tamanoPantallaYTooltippAcomoda = tamanoPantallaYTooltippAcomoda + preguntaMainPincipal.frame.size.height + 100.0
            
            pregImageInstrucciones.frame = CGRect(x: 10.0, y: tamanoPantallaYTooltippAcomoda, width: tamanoPantallaXTooltipp - 20.0 , height: 10.0)
            
            scrollPreguntas.addSubview(pregImageInstrucciones)
            
            //self.view.addSubview(scrollView)
            
        }else{
            
            imagenSiNo = true
            
             print("imagenPreguntaMain: \(arrayPreguntas[contador]["imagentooltip"]!)")
            
        let bundlePath = Bundle.main.path(forResource: arrayPreguntas[contador]["imagentooltip"]!.trimmingCharacters(in: .whitespaces), ofType: nil)
            
            let image: UIImage = UIImage(contentsOfFile: bundlePath!)!
            
            imagenPreguntaMain = arrayPreguntas[contador]["imagentooltip"]!
            let imageView = UIImageView(image: image)

            imageView.image = UIImage(contentsOfFile: bundlePath!)
    
            // create an NSMutableAttributedString that we'll append everything to
            let fullString = NSMutableAttributedString(string: "")
            
            // create our NSTextAttachment
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = UIImage(contentsOfFile: bundlePath!)
            
            // wrap the attachment in its own attributed string so we can append it
            let image1String = NSAttributedString(attachment: image1Attachment)
            
            // add the NSTextAttachment wrapper to our full string, then add some more text.
            fullString.append(image1String)
            //fullString.append(NSAttributedString(string: "End of text"))

            // draw the result in a label
            self.preguntaMainPincipal.attributedText = fullString
            
            var frame = self.preguntaMainPincipal.frame
            frame.size.height = self.preguntaMainPincipal.contentSize.height
            self.preguntaMainPincipal.frame = frame

            pregImageInstrucciones.text = arrayPreguntas[contador]["tooltip"]!.trimmingCharacters(in: .whitespaces)
            
            pregImageInstrucciones.frame = CGRect(x: 10.0, y: tamanoPantallaYTooltippAcomoda, width: tamanoPantallaXTooltipp - 20.0 , height: tamanoPantallaYTooltipp)
            
            pregImageInstrucciones.isScrollEnabled = false
            
            pregImageInstrucciones.translatesAutoresizingMaskIntoConstraints = true
            pregImageInstrucciones.sizeToFit()
            pregImageInstrucciones.isEditable = false
            pregImageInstrucciones.isSelectable = false
            
            let fixedWidth = pregImageInstrucciones.frame.size.width
            
            let newSize = pregImageInstrucciones.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            
            pregImageInstrucciones.frame.size = CGSize(width: tamanoPantallaXTooltipp - 20.0, height: newSize.height)

            scrollPreguntas.addSubview(pregImageInstrucciones)            //self.view.addSubview(scrollView)
            
            tamanoPantallaYTooltippAcomoda = tamanoPantallaYTooltippAcomoda + pregImageInstrucciones.frame.size.height + 30.0

            
            preguntaMainPincipal.frame = CGRect(x: 10.0, y: tamanoPantallaYTooltippAcomoda, width: tamanoPantallaXTooltipp - 20.0 , height: tamanoPantallaYTooltipp)
            
            preguntaMainPincipal.isScrollEnabled = false
            
            preguntaMainPincipal.translatesAutoresizingMaskIntoConstraints = true
            preguntaMainPincipal.sizeToFit()
            preguntaMainPincipal.isEditable = false
            preguntaMainPincipal.isSelectable = false
            
            let fixedWidthPreg = preguntaMainPincipal.frame.size.width
            
            let newSizePreg = preguntaMainPincipal.sizeThatFits(CGSize(width: fixedWidthPreg, height: CGFloat.greatestFiniteMagnitude))
            
            preguntaMainPincipal.frame.size = CGSize(width: tamanoPantallaXTooltipp, height: newSizePreg.height)
            
            scrollPreguntas.addSubview(preguntaMainPincipal)
            
            //self.view.addSubview(scrollView)
            
            tamanoPantallaYTooltippAcomoda = tamanoPantallaYTooltippAcomoda + pregImageInstrucciones.frame.size.height + 100.0
            
        }
        
        adjustUITextViewHeight(arg: preguntaMainPincipal)
        adjustUITextViewHeight(arg: pregImageInstrucciones)
        
        print("tamanoPantallaYTooltippAcomoda: \(tamanoPantallaYTooltippAcomoda)")
        
 
        arrayRespuestas = []
        if(arrayPreguntas[contador]["respuestauno"]! != ""){
            arrayRespuestas.append(arrayPreguntas[contador]["respuestauno"]!)
        }
        if(arrayPreguntas[contador]["respuestados"]! != ""){
            arrayRespuestas.append(arrayPreguntas[contador]["respuestados"]!)
        }
        if(arrayPreguntas[contador]["respuestatres"]! != ""){
            arrayRespuestas.append(arrayPreguntas[contador]["respuestatres"]!)
        }
        if(arrayPreguntas[contador]["respuestacuatro"]! != ""){
            arrayRespuestas.append(arrayPreguntas[contador]["respuestacuatro"]!)
        }
        
     
        //  }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    func reloadTabla(){
        self.preguntaMainPincipal.becomeFirstResponder()
        self.pregImageInstrucciones.becomeFirstResponder()
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if segue.identifier == "muestraResultados"{
                print("materia: \(materia!)")
                let correctasFinalTotal = "\(contadorCorrectas)"
                let objVista2 = segue.destination as! ResultadosMateriaViewController
                objVista2.asignatura = materia
                objVista2.preguntasRealizadas = numPreguntas
                objVista2.resultadoFinal = correctasFinalTotal
            }
        
            if segue.identifier == "vermoduloRepaso"{
                
                print("nombreMateria: \(nombreMateria)")
                let objVista2 = segue.destination as! PreguntasModuloViewController
                objVista2.materia = nombreMateria
                objVista2.numPreguntas = numPreguntas
                objVista2.ayuda = ayuda
                objVista2.arrayPreguntas = arrayPreguntas
                
            }

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


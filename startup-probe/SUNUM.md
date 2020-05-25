## StartUp Probe

Bazi uygulamalar yapilari itibariyle gec traffic alacak duruma gelebilir bu nedenle livenessProbe'lara cevap veremedikleri durumda kendi icinde restart edilmeye baslamaktadir.

Bu durumu asmak amaciyla startUpProbe adiyla yeni bir probe eklenerek livenessProbe oncesi ek bir check yapilarak uygulamanin ayaga kalkmasi durumu icin ek bir kontrol yapilabilir.


Eger ki uygulamalariniz : `initialDelaySeconds + failureThreshold × periodSeconds` daha uzun bir surede ayaga kalkiyorsa bu sekilde bir check ekleyebilirsiniz.


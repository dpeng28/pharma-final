library(matlabr)
library(R.matlab)
library(ggplot2)

# plot mass balance 
#######
balance = readMat("balance.mat")

plotDf = data.frame(time = as.vector(balance[1]), conc = balance[2])

basePlot <- ggplot(plotDf, aes(t, balance)) + 
    geom_line(data = plotDf, size = 1.2) + 
    ggtitle("Mass Balance of Metformin")+
    ylab("Concentration - mg")+
    xlab("Time - hours")+
    theme_bw()+
    theme(text = element_text(size=24))



# plot single dose metformin

# plot single dose 
###### 
metConc = readMat("../GUI_final/Data/dosedietsingle.mat")
# glucose_change == glucose without diet 
# blood glucose == glucose with diet 
metConcType = c("GI_lumen", "GI_wall", "liver", "periphery", "blood_woDiet", "glucose_wDiet")

concPlotDf = data.frame(time = NULL, conc = NULL, compartment = NULL)
concMatrix = metConc$y
for(i in 1:4) {
    tempDf = data.frame(time = metConc$t, conc = concMatrix[, i], compartment = metConcType[i])
    concPlotDf = rbind(concPlotDf, tempDf)
}

glucoseNoDiet = data.frame(time = metConc$t, yaxis = concMatrix[, 5])
glucoseDiet = data.frame(time = metConc$t, yaxis = concMatrix[, 6])

# metforming plotting 
ggplot(concPlotDf, aes(time, conc, color = compartment)) + 
    geom_line(data = concPlotDf, size = 1.2) + 
    ggtitle("Metformin Amount Over Time")+
    ylab("Amount - mg")+
    xlab("Time - hours")+
    theme_bw()+
    theme(text = element_text(size=20))

# glucose no diet plotting
ggplot(glucoseNoDiet, aes(time, yaxis)) + 
    geom_line(data = glucoseNoDiet, size = 1.2) + 
    ggtitle("Glucose Concentration without Glucose Input")+
    ylab("Concentration - mg/dL")+
    xlab("Time - hours")+
    theme_bw()+
    theme(text = element_text(size=20))

# glucose with diet plotting
ggplot(glucoseDiet, aes(time, yaxis)) + 
    geom_line(data = glucoseDiet, size = 1.2) + 
    ggtitle("Glucose Concentration with Glucose Input")+
    ylab("Concentration - mg/dL")+
    xlab("Time - hours")+
    theme_bw()+
    theme(text = element_text(size=20))


# plot metformin amount in live r

# plot different dose scheme
#####
diffDoseRaw = readMat("difdose.mat")
doseScheme = c("placeHold", "500mg", "700mg", "1500mg", "550mg", "200mg")

liverPlot = data.frame(time = NULL, amount = NULL, Dose_Amount = NULL)
for(myIndex in 2:6) {
    tempLiver = data.frame(time = diffDoseRaw[1], amount = diffDoseRaw[[myIndex]][,3], Dose_Amount = doseScheme[myIndex])
    liverPlot = rbind(liverPlot, tempLiver)
    print(myIndex)
}
secondLiverPlot = liverPlot

liverPlot = rbind(liverPlot[liverPlot$Dose_Amount == "1500mg",], 
                  liverPlot[liverPlot$Dose_Amount == "700mg",], 
                  liverPlot[liverPlot$Dose_Amount == "550mg",],
                  liverPlot[liverPlot$Dose_Amount == "500mg",], 
                  liverPlot[liverPlot$Dose_Amount == "200mg",])

# metforming liver plotting 
ggplot(liverPlot, aes(t, amount, color = Dose_Amount)) + 
    geom_line(data = liverPlot, size = 1.2) + 
    ggtitle("Metformin Amount in Liver Over Time")+
    ylab("Amount - mg")+
    xlab("Time - hours")+
    theme_bw()+
    theme(text = element_text(size=20))

# plot periphery 
bloodPlot = data.frame(time = NULL, amount = NULL, Dose_Amount = NULL)
for(myIndex in 2:5) {
    temp = data.frame(time = diffDoseRaw[1], amount = diffDoseRaw[[myIndex]][,4], Dose_Amount = doseScheme[myIndex])
    bloodPlot = rbind(bloodPlot, temp)
    print(myIndex)
}

ggplot(bloodPlot, aes(t, amount, color = Dose_Amount)) + 
    geom_line(data = bloodPlot, size = 1.2) + 
    ggtitle("Metformin Amount in Blood Over Time")+
    ylab("Amount - mg")+
    xlab("Time - hours")+
    theme_bw()+
    theme(text = element_text(size=20))

# plot glucoseConc without diet  
gluPlot = data.frame(time = NULL, amount = NULL, Dose_Amount = NULL)
for(myIndex in 2:5) {
    temp = data.frame(time = diffDoseRaw[1], amount = diffDoseRaw[[myIndex]][,5], Dose_Amount = doseScheme[myIndex])
    gluPlot = rbind(gluPlot, temp)
    print(myIndex)
}

ggplot(gluPlot, aes(t, amount, color = Dose_Amount)) + 
    geom_line(data = gluPlot, size = 1.2) + 
    ggtitle("Blood Glucose Concentration[No Food Intake]")+
    ylab("Amount - mg/dL")+
    xlab("Time - hours")+
    theme_bw()+
    theme(text = element_text(size=20))

# plot glucoseConc With diet  
gluPlot = data.frame(time = NULL, amount = NULL, Dose_Amount = NULL)
for(myIndex in 2:5) {
    temp = data.frame(time = diffDoseRaw[1], amount = diffDoseRaw[[myIndex]][,6], Dose_Amount = doseScheme[myIndex])
    gluPlot = rbind(gluPlot, temp)
    print(myIndex)
}

ggplot(gluPlot, aes(t, amount, color = Dose_Amount)) + 
    geom_line(data = gluPlot, size = 1.2) + 
    ggtitle("Blood Glucose Concentration[Food Intake]")+
    ylab("Amount - mg/dL")+
    xlab("Time - hours")+
    theme_bw()+
    theme(text = element_text(size=20))


# plot multidose 
metConcMD = readMat("multidose(5).mat")
metConcType = c("GI_lumen", "GI_wall", "liver", "periphery", "blood_woDiet", "glucose_wDiet")

concPlotMDDf = data.frame(time = NULL, conc = NULL, compartment = NULL)
concMatrix = metConcMD$TotalDo

for(i in 1:4) {
    tempDf = data.frame(time = metConcMD$To1, conc = concMatrix[, i], compartment = metConcType[i])
    concPlotMDDf = rbind(concPlotMDDf, tempDf)
}

glucoseNoDietMD = data.frame(time = metConcMD$To1, yaxis = concMatrix[, 5])
glucoseDietMD = data.frame(time = metConcMD$To1, yaxis = concMatrix[, 6])

# metformin GI lumin 
ggplot(concPlotMDDf[concPlotMDDf$compartment == "GI_lumen", ], aes(time, conc)) + 
    geom_line(size = 1.2) + 
    ggtitle("Metformin in GI Lumen")+
    ylab("Amount - mg")+
    xlab("Time - hours")+
    theme_bw()+
    theme(text = element_text(size=18))

# metformin blood
ggplot(concPlotMDDf[concPlotMDDf$compartment == "periphery", ], aes(time, conc)) + 
    geom_line(size = 1.2) + 
    ggtitle("Metformin in Periphery")+
    ylab("Amount - mg")+
    xlab("Time - hours")+
    theme_bw()+
    theme(text = element_text(size=18))

# glucose no diet plotting
ggplot(glucoseNoDietMD, aes(time, yaxis)) + 
    geom_line(size = 1.2) + 
    ggtitle("Glucose Concentration without Glucose Input")+
    ylab("Concentration - mg/dL")+
    xlab("Time - hours")+
    theme_bw()+
    theme(text = element_text(size=20))

# glucose with diet plotting
ggplot(glucoseDietMD, aes(time, yaxis)) + 
    geom_line(data = glucoseDietMD, size = 1.2) + 
    ggtitle("Glucose Concentration with Glucose Input")+
    ylab("Concentration - mg/dL")+
    xlab("Time - hours")+
    theme_bw()+
    theme(text = element_text(size=20))


# plot multidose and missdose
#####
data = readMat("../GUI_final/Data/multidose_personalizeMatlab/multidose.mat")

metConcType = c("GI_lumen", "GI_wall", "liver", "periphery", "blood_woDiet", "glucose_wDiet")

concPlotPM = data.frame(time = NULL, conc = NULL, compartment = NULL)
concMatrix = data$TotalDo

#timeGlu = timeGlu[timeGlu != -1]
#timeMet = timeMet[timeMet != -1]

#minGlu = min(timeGlu)
#minMet = min(timeMet)

minGlu = 7
minMet = 7
glucoseDietPM = data.frame(time = (data$To1 / 60 + min(minGlu, minMet)), yaxis = concMatrix[, 6])

ggplot(glucoseDietPM, aes(time, yaxis)) + 
    geom_line(data = glucoseDietPM, size = 1.2) + 
    ylab("Concentration - mg/dL")+
    xlab("Time - hours")+
    geom_hline(yintercept=100, linetype="dashed", color = "green", size=1)+
    geom_hline(yintercept=70, linetype="dashed", color = "red", size=1)+
    theme_bw() +
    theme(text = element_text(size=20))

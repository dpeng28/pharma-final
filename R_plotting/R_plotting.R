library(matlabr)
library(R.matlab)
library(ggplot2)

# plot mass balance 
#######
balance = readMat("balance.mat")

plotDf = data.frame(time = as.vector(balance[1]), conc = balance[2])
scientific_10 <- function(x) {
    parse(text=gsub("e", " %*% 10^", scales::scientific_format()(x)))
}
ggplot(plotDf, aes(t, balance)) + 
    geom_line(data = plotDf, size = 1.2) + 
    ggtitle("Mass Balance of Metformin")+
    ylab("Amount - mg")+
    xlab("Time - min")+
    scale_y_continuous(label=scientific_10)+
    theme_bw()+
    theme(text = element_text(size=20))



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
    xlab("Time - min")+
    theme_bw()+
    theme(text = element_text(size=20), legend.position=c(.8, .6))

# focused in 

glucoseDiet$Diet_Status = "With Food"
glucoseNoDiet$Diet_Status = "No Food"
glcosePlot = rbind(glucoseDiet, glucoseNoDiet)

ggplot(glcosePlot, aes(time, yaxis, color = Diet_Status)) + 
    geom_line(data = glcosePlot, size = 1.2) + 
    ggtitle("Glucose Concentration")+
    ylab("Concentration - mg/dL")+
    xlab("Time - min")+
    theme_bw()+
    theme(text = element_text(size=20), legend.position=c(.8, .6))

# metforming plotting 
ggplot(concPlotDf, aes(time, conc, color = compartment)) + 
    geom_line(data = concPlotDf, size = 1.2) + 
    ggtitle("Metformin Amount Over Time-Zoomed In")+
    ylab("Amount - mg")+
    xlab("Time - min")+
    ylim(c(0, 15))+
    theme_bw()+
    theme(text = element_text(size=20), legend.position=c(.8, .6))

# glucose no diet plotting
ggplot(glucoseNoDiet, aes(time, yaxis)) + 
    geom_line(data = glucoseNoDiet, size = 1.2) + 
    ggtitle("Glucose Concentration without Glucose Input")+
    ylab("Concentration - mg/dL")+
    xlab("Time - min")+
    theme_bw()+
    theme(text = element_text(size=20))

# glucose with diet plotting
ggplot(glucoseDiet, aes(time, yaxis)) + 
    geom_line(data = glucoseDiet, size = 1.2) + 
    ggtitle("Glucose Concentration with Glucose Input")+
    ylab("Concentration - mg/dL")+
    xlab("Time - min")+
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
liverPlot$Dose_Amount <- factor(liverPlot$Dose_Amount, levels = c("1500mg", "700mg", "550mg", "500mg", "200mg"))
liverPlot$miniTitle = "Metformin Amount in Liver Over Time"

# metforming liver plotting 
ggplot(liverPlot, aes(t, amount, color = Dose_Amount)) + 
    geom_line(data = liverPlot, size = 1.2) + 
    ggtitle("Metformin Amount in Liver Over Time")+
    ylab("Amount - mg")+
    xlab("Time - min")+
    theme_bw()+
    theme(text = element_text(size=20), legend.position = c(0.8, 0.6))

# plot periphery 
bloodPlot = data.frame(time = NULL, amount = NULL, Dose_Amount = NULL)
for(myIndex in 2:6) {
    temp = data.frame(time = diffDoseRaw[1], amount = diffDoseRaw[[myIndex]][,4], Dose_Amount = doseScheme[myIndex])
    bloodPlot = rbind(bloodPlot, temp)
    print(myIndex)
}

bloodPlot$Dose_Amount <- factor(bloodPlot$Dose_Amount, levels = c("1500mg", "700mg", "550mg", "500mg", "200mg"))
bloodPlot$miniTitle = "Metformin Amount in Blood Over Time"
ggplot(bloodPlot, aes(t, amount, color = Dose_Amount)) + 
    geom_line(data = bloodPlot, size = 1.2) + 
    ggtitle("Metformin Amount in Blood Over Time")+
    ylab("Amount - mg")+
    xlab("Time - min")+
    theme_bw()+
    theme(text = element_text(size=20), legend.position = c(0.8, 0.6))

# plot glucoseConc without diet  
gluPlot = data.frame(time = NULL, amount = NULL, Dose_Amount = NULL)
for(myIndex in 2:6) {
    temp = data.frame(time = diffDoseRaw[1], amount = diffDoseRaw[[myIndex]][,5], Dose_Amount = doseScheme[myIndex])
    gluPlot = rbind(gluPlot, temp)
    print(myIndex)
}

gluPlot$Dose_Amount <- factor(gluPlot$Dose_Amount, levels = c("1500mg", "700mg", "550mg", "500mg", "200mg"))
gluPlot1 = gluPlot
gluPlot1$miniTitle = "Blood Glucose Concentration[No Food Intake]"

ggplot(gluPlot, aes(t, amount, color = Dose_Amount)) + 
    geom_line(data = gluPlot, size = 1.2) + 
    ggtitle("Blood Glucose Concentration[No Food Intake]")+
    ylab("Amount - mg/dL")+
    xlab("Time - min")+
    theme_bw()+
    theme(text = element_text(size=20), legend.position = c(0.75, 0.75))

# plot glucoseConc With diet  
gluPlot = data.frame(time = NULL, amount = NULL, Dose_Amount = NULL)
for(myIndex in 2:6) {
    temp = data.frame(time = diffDoseRaw[1], amount = diffDoseRaw[[myIndex]][,6], Dose_Amount = doseScheme[myIndex])
    gluPlot = rbind(gluPlot, temp)
    print(myIndex)
}
gluPlot$Dose_Amount <- factor(gluPlot$Dose_Amount, levels = c("1500mg", "700mg", "550mg", "500mg", "200mg"))
gluPlot$miniTitle = "Blood Glucose Concentration[Food Intake]"
    
ggplot(gluPlot, aes(t, amount, color = Dose_Amount)) + 
    geom_line(data = gluPlot, size = 1.2) + 
    ggtitle("Blood Glucose Concentration[Food Intake]")+
    ylab("Amount - mg/dL")+
    xlab("Time - min")+
    theme_bw()+
    theme(text = element_text(size=20), legend.position = c(0.75, 0.75))


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
    xlab("Time - min")+
    xlim(0, 1100)+
    theme_bw()+
    theme(text = element_text(size=18))

# metformin blood
ggplot(concPlotMDDf[concPlotMDDf$compartment == "periphery", ], aes(time, conc)) + 
    geom_line(size = 1.2) + 
    ggtitle("Metformin in Periphery")+
    ylab("Amount - mg")+
    xlab("Time - min")+
    xlim(0, 1100)+
    theme_bw()+
    theme(text = element_text(size=18))

# glucose no diet plotting
ggplot(glucoseNoDietMD, aes(time, yaxis)) + 
    geom_line(size = 1.2) + 
    ggtitle("Glucose Concentration without Glucose Input")+
    ylab("Concentration - mg/dL")+
    xlab("Time - min")+
    xlim(0, 1100)+
    theme_bw()+
    theme(text = element_text(size=20))

# glucose with diet plotting
ggplot(glucoseDietMD, aes(time, yaxis)) + 
    geom_line(data = glucoseDietMD, size = 1.2) + 
    ggtitle("Glucose Concentration with Glucose Input")+
    ylab("Concentration - mg/dL")+
    xlab("Time - min")+
    xlim(0, 1100)+
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


#####
# plot heatmap 
# load in the sensitivity data for young population 
sensYoung = read.table("../GUI_final/Data/young_sens.txt")
colnames(sensYoung) = c('kg0', 'kgg', 'kgl', 'klp', 'kpl', 'kpg', 'kp0', 'kin', 'dose')
rownames(sensYoung) = c('Drug AUC', 'Drug Ctrough', 'Glucose Ctrough')
melt_sensYoung = data.frame(parameters = NULL, target = NULL, value = NULL)
for(myParam in colnames(sensYoung)) {
    for(myTarget in rownames(sensYoung)) {
        tempDf = data.frame(parameters = myParam, target = myTarget, norm_sens = sensYoung[myTarget, myParam])
        melt_sensYoung = rbind(melt_sensYoung, tempDf)
    }
}

# load in the sensitivity data for older mid age population 
sensMid = read.table("../GUI_final/Data/mid_sens.txt")
colnames(sensMid) = c('kg0', 'kgg', 'kgl', 'klp', 'kpl', 'kpg', 'kp0', 'kin', 'dose')
rownames(sensMid) = c('Drug AUC', 'Drug Ctrough', 'Glucose Ctrough')
melt_sensMid = data.frame(parameters = NULL, target = NULL, value = NULL)
for(myParam in colnames(sensMid)) {
    for(myTarget in rownames(sensMid)) {
        tempDf = data.frame(parameters = myParam, target = myTarget, norm_sens = sensMid[myTarget, myParam])
        melt_sensMid = rbind(melt_sensMid, tempDf)
    }
}

# load in the sensitivity data for older mid age population 
sensOld = read.table("../GUI_final/Data/old_sens.txt")
colnames(sensOld) = c('kg0', 'kgg', 'kgl', 'klp', 'kpl', 'kpg', 'kp0', 'kin', 'dose')
rownames(sensOld) = c('Drug AUC', 'Drug Ctrough', 'Glucose Ctrough')
melt_sensOld = data.frame(parameters = NULL, target = NULL, value = NULL)

for(myParam in colnames(sensOld)) {
    for(myTarget in rownames(sensOld)) {
        tempDf = data.frame(parameters = myParam, target = myTarget, norm_sens = sensOld[myTarget, myParam])
        melt_sensOld = rbind(melt_sensOld, tempDf)
    }
}

plotSens <- function(meltedSensDf) {
    mycol <- c("darkgreen", 'white', 'darkred')
    
    p = ggplot(meltedSensDf, aes(parameters, target)) +
        scale_fill_gradientn(colours = mycol)+
        labs(fill = "Normalized \n Sensitivity")+
        theme(text = element_text(size=24))+
        xlab("Parameters") +
        ylab("Targets") +
        geom_tile(aes(fill = norm_sens))
    
    # return 
    p
}

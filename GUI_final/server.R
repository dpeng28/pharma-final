library(shiny)
library(shinydashboard)
library(R.matlab)
library(ggplot2)
library(reshape)
library(plotly)
library(matlabr)
library(slickR)

myMatlabPath = "C:/Program Files/MATLAB/R2019a/bin" # change this as appropriate 
setwd(paste0(getwd(), "/Data"))

# load in young population 
popYoung = readMat("young_pop_data.mat")
popYoung = popYoung[[1]]
colnames(popYoung) = c('weight', 'height', 'kg0', 'kgg', 'kgl', 'kls', 'ksl', 'ksg', 'ks0', 'kin', 'Ctrough_drug_blood', 'Ctrough_glucose_blood', 'AUC_drug_blood')

# load in mid population 
popMid = readMat("mid_pop_data.mat")
popMid = popMid[[1]]
colnames(popMid) = c('weight', 'height', 'kg0', 'kgg', 'kgl', 'kls', 'ksl', 'ksg', 'ks0', 'kin', 'Ctrough_drug_blood', 'Ctrough_glucose_blood', 'AUC_drug_blood')

# load in old population 
popOld = readMat("old_pop_data.mat")
popOld = popOld[[1]]
colnames(popOld) = c('weight', 'height', 'kg0', 'kgg', 'kgl', 'kls', 'ksl', 'ksg', 'ks0', 'kin', 'Ctrough_drug_blood', 'Ctrough_glucose_blood', 'AUC_drug_blood')

plotBoxPop <- function(popYoung, popMid, popOld, selection) {
    unitsList = c("kg", "cm", "min-1", "min-1", "min-1", "min-1", "min-1", "min-1", "min-1", "mg/dl/min", "mg/dl", "mg/dl", "mg/dl * t")
    
    targetParam = colnames(popYoung)[selection]
    
    youngDf = data.frame(value = as.vector(popYoung[, selection]), variable = targetParam, population = "Young Population")
    midDf = data.frame(value = as.vector(popMid[, selection]), variable = targetParam, population = "Mid Population")
    oldDf = data.frame(value = as.vector(popOld[, selection]), variable = targetParam, population = "Old Population")
    
    plotDf = rbind(youngDf, midDf, oldDf)
    
    p = ggplot(plotDf, aes(x=population, y=value, fill=population)) +
        geom_boxplot() + 
        theme(text = element_text(size=14))+
        xlab("Population type") + 
        ylab(paste0(targetParam, " - ", unitsList[selection]))
    
    # return 
    ggplotly(p)   
}
# load in the sensitivity data for young population 
sensYoung = read.table("young_sens.txt")
colnames(sensYoung) = c('kg0', 'kgg', 'kgl', 'klp', 'kpl', 'kpg', 'kp0', 'kin', 'dose')
rownames(sensYoung) = c('AUC', 'Ctrough_drug', 'Ctrough_glucose')
melt_sensYoung = data.frame(parameters = NULL, target = NULL, value = NULL)
for(myParam in colnames(sensYoung)) {
    for(myTarget in rownames(sensYoung)) {
        tempDf = data.frame(parameters = myParam, target = myTarget, value = sensYoung[myTarget, myParam])
        melt_sensYoung = rbind(melt_sensYoung, tempDf)
    }
}

# load in the sensitivity data for older mid age population 
sensMid = read.table("mid_sens.txt")
colnames(sensMid) = c('kg0', 'kgg', 'kgl', 'klp', 'kpl', 'kpg', 'kp0', 'kin', 'dose')
rownames(sensMid) = c('AUC', 'Ctrough_drug', 'Ctrough_glucose')
melt_sensMid = data.frame(parameters = NULL, target = NULL, value = NULL)
for(myParam in colnames(sensMid)) {
    for(myTarget in rownames(sensMid)) {
        tempDf = data.frame(parameters = myParam, target = myTarget, value = sensMid[myTarget, myParam])
        melt_sensMid = rbind(melt_sensMid, tempDf)
    }
}

# load in the sensitivity data for older mid age population 
sensOld = read.table("old_sens.txt")
colnames(sensOld) = c('kg0', 'kgg', 'kgl', 'klp', 'kpl', 'kpg', 'kp0', 'kin', 'dose')
rownames(sensOld) = c('AUC', 'Ctrough_drug', 'Ctrough_glucose')
melt_sensOld = data.frame(parameters = NULL, target = NULL, value = NULL)

for(myParam in colnames(sensOld)) {
    for(myTarget in rownames(sensOld)) {
        tempDf = data.frame(parameters = myParam, target = myTarget, value = sensOld[myTarget, myParam])
        melt_sensOld = rbind(melt_sensOld, tempDf)
    }
}

plotSens <- function(meltedSensDf) {
    mycol <- c("darkgreen", 'white', 'darkred')
    
    p = ggplot(meltedSensDf, aes(parameters, target)) +
        scale_fill_gradientn(colours = mycol)+
        theme(text = element_text(size=20))+
        xlab("Parameters") +
        ylab("Targets") +
        geom_tile(aes(fill = value))
    
    #return 
    ggplotly(p)
}

metConc = readMat("dosedietsingle.mat")
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

metConcMD = readMat("multidose.mat")
metConcType = c("GI_lumen", "GI_wall", "liver", "periphery", "blood_woDiet", "glucose_wDiet")

concPlotMDDf = data.frame(time = NULL, conc = NULL, compartment = NULL)
concMatrix = metConcMD$TotalDo

for(i in 1:4) {
    tempDf = data.frame(time = metConcMD$To1, conc = concMatrix[, i], compartment = metConcType[i])
    concPlotMDDf = rbind(concPlotMDDf, tempDf)
}

glucoseNoDietMD = data.frame(time = metConcMD$To1, yaxis = concMatrix[, 5])
glucoseDietMD = data.frame(time = metConcMD$To1, yaxis = concMatrix[, 6])


plotGlucose <- function(plotDf, yRange, timeRange) {
    basePlot <- ggplot(plotDf, aes(time, yaxis)) + 
        geom_line(data = plotDf, size = 1.2) + 
        ylab("Concentration - mg/dL")+
        xlab("Time - hours")+
        ylim(yRange[1], yRange[2])+
        xlim(timeRange[1], timeRange[2])+
        theme(text = element_text(size=14))+
        theme_bw()
    
    returnP <- ggplotly(basePlot)
    #return
    returnP
}

plotConcSim <- function(concPlotDf, concRange, timeRange){
    basePlot <- ggplot(concPlotDf, aes(time, conc, color = compartment)) + 
        geom_line(data = concPlotDf, size = 1.2) + 
        ylab("Amount - mg")+
        xlab("Time - hours")+
        ylim(concRange[1], concRange[2])+
        xlim(timeRange[1], timeRange[2])+
        theme(text = element_text(size=14))+
        theme_bw()
    
    returnP <- ggplotly(basePlot)
    #return
    returnP
}

plotFitData <- function(sampleFit) {
    simData = data.frame(time = sampleFit$t, metConc = sampleFit$y4, type = "simulation")
    expData = data.frame(time = as.vector(sampleFit$texp), metConc = as.vector(sampleFit$yexp), type = "expData")
    
    
    basePlot <- ggplot(simData, aes(time, metConc)) + 
        geom_line(data = simData, size = 1.2) + 
        geom_point(data = expData, size = 2, color = 'red')+
        ylab("Concentration - mg/L")+
        xlab("Time - Hour")+
        theme(text = element_text(size=14))+
        theme_bw()
        
}

plotPersonalGlucose <- function(amountMet, 
                                amountGlu, 
                                timeGlu1, 
                                timeGlu2, 
                                timeGlu3, 
                                timeMet1, 
                                timeMet2,
                                timeMet3, 
                                weight, 
                                age) {
    timeGlu <- c(timeGlu1, timeGlu2, timeGlu3)
    timeMet <- c(timeMet1, timeMet2, timeMet3)
    
    outputData <- data.frame(amountMet = amountMet, timeMet = timeMet, amountGlu = amountGlu, timeGlu = timeGlu, weight = weight, age = age)
    
    write.csv(outputData, file = "multidose_personalizeMatlab/personal_matlab.csv")
    
    options(matlab.path = myMatlabPath)
    have_matlab()
    run_matlab_script(fname = "multidose_personalizeMatlab/run.m")
    
    data = readMat("multidose_personalizeMatlab/multidose.mat")
    
    metConcType = c("GI_lumen", "GI_wall", "liver", "periphery", "blood_woDiet", "glucose_wDiet")
    
    concPlotPM = data.frame(time = NULL, conc = NULL, compartment = NULL)
    concMatrix = data$TotalDo
    
    timeGlu = timeGlu[timeGlu != -1]
    timeMet = timeMet[timeMet != -1]
    
    minGlu = min(timeGlu)
    minMet = min(timeMet)
    
    glucoseDietPM = data.frame(time = (data$To1 / 60 + min(minGlu, minMet)), yaxis = concMatrix[, 6])
    
    basePlot <- ggplot(glucoseDietPM, aes(time, yaxis)) + 
        geom_line(data = glucoseDietPM, size = 1.2) + 
        ylab("Concentration - mg/dL")+
        xlab("Time - hours")+
        geom_hline(yintercept=100, linetype="dashed", color = "green", size=1)+
        geom_hline(yintercept=70, linetype="dashed", color = "red", size=1)+
        theme(text = element_text(size=14))+
        theme_bw()
    
    returnP <- ggplotly(basePlot)
    #return
    returnP
    
}

plotPersonalMetformin <- function(amountMet, 
                               amountGlu, 
                               timeGlu1, 
                               timeGlu2, 
                               timeGlu3, 
                               timeMet1, 
                               timeMet2,
                               timeMet3, 
                               weight, 
                               age) {
    timeGlu <- c(timeGlu1, timeGlu2, timeGlu3)
    timeMet <- c(timeMet1, timeMet2, timeMet3)
    
    outputData <- data.frame(amountMet = amountMet, timeMet = timeMet, amountGlu = amountGlu, timeGlu = timeGlu, weight = weight, age = age)
    
    write.csv(outputData, file = "multidose_personalizeMatlab/personal_matlab.csv")
    
    options(matlab.path = myMatlabPath)
    have_matlab()
    run_matlab_script(fname = "multidose_personalizeMatlab/run.m")
    
    data = readMat("multidose_personalizeMatlab/multidose.mat")
    
    metConcType = c("GI_lumen", "GI_wall", "liver", "periphery", "blood_woDiet", "glucose_wDiet")
    
    concPlotPM = data.frame(time = NULL, conc = NULL, compartment = NULL)
    concMatrix = data$TotalDo
    
    timeGlu = timeGlu[timeGlu != -1]
    timeMet = timeMet[timeMet != -1]
    
    minGlu = min(timeGlu)
    minMet = min(timeMet)
    for(i in 1:4) {
        tempDf = data.frame(time = (data$To1 / 60 + min(minGlu, minMet)), conc = concMatrix[, i], compartment = metConcType[i])
        concPlotPM = rbind(concPlotPM, tempDf)
    }
    
    basePlot <- ggplot(concPlotPM, aes(time, conc, color = compartment)) + 
        geom_line(data = concPlotPM, size = 1.2) + 
        ylab("Amount - mg")+
        xlab("Time - hours")+
        theme(text = element_text(size=14))+
        theme_bw()
    
    returnP <- ggplotly(basePlot)
    #return
    returnP
}

shinyServer(function(input, output) {
    
    output$metTimeSeries <- renderPlotly({
        plotConcSim(concPlotDf, input$sliderMetConc, input$sliderTime)
    })
    
    output$bloodGluWDiet <- renderPlotly({
        plotGlucose(plotDf = glucoseDiet, input$sliderGluDiet, input$sliderGluDietTime)
    })
    
    output$bloodGluWODiet <- renderPlotly({
        plotGlucose(plotDf = glucoseNoDiet, input$sliderGluNoDiet, input$sliderGluNoDietTime)
    })
    
    output$`metTimeSeries-MD`<-renderPlotly({
        plotConcSim(concPlotMDDf, input$`sliderMetConc-MD`, input$`sliderTime-MD`)
    })
    
    output$`bloodGluWdiet-MD`<- renderPlotly({
        plotGlucose(plotDf = glucoseDietMD, input$`sliderGluDiet-MD`, input$`sliderGluDietTime-MD`)
    })
    
    output$`bloodGluWOdiet-MD`<- renderPlotly({
        plotGlucose(plotDf = glucoseNoDietMD, input$`sliderGluNoDiet-MD`, input$`sliderGluNoDietTime-MD`)
    })

    output$midSens <- renderPlotly({
        plotSens(meltedSensDf = melt_sensMid)
    })
    output$oldSens <- renderPlotly({
        plotSens(meltedSensDf = melt_sensOld)
    })
    output$youngSens <- renderPlotly({
        plotSens(meltedSensDf = melt_sensYoung)
    })
    
    output$popBoxPlot <- renderPlotly({
        plotBoxPop(popYoung, popMid, popOld, as.integer(input$selectPopParameters))
    })
    
    output$`metTimeSeries-PM`<- renderPlotly({
        plotPersonalMetformin(amountMet = input$dailyMetforminInput, 
                              amountGlu = input$dailyGlucoseInput, 
                              input$meal1, 
                              input$meal2, 
                              input$meal3, 
                              input$met1, 
                              input$met2, 
                              input$met3, 
                              input$yourWeight, 
                              input$yourAge)
    })
    
    output$`bloodGluWdiet-PM`<- renderPlotly({
        plotPersonalGlucose(amountMet = input$dailyMetforminInput, 
                            amountGlu = input$dailyGlucoseInput, 
                            input$meal1, 
                            input$meal2, 
                            input$meal3, 
                            input$met1, 
                            input$met2, 
                            input$met3, 
                            input$yourWeight, 
                            input$yourAge)
    })
    
    output$slickr <- renderSlickR({
        imgs <- list.files("SlideShow/", pattern=".png", full.names = TRUE)
        slickR(imgs)
    })
  
})

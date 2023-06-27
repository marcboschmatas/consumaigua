#' @title diag_plot
#' @param model a lm object
#' @import ggplot2
#' @importFrom cowplot plot_grid
#' @returns a grid with diagnostic plots
#' @export

# inspired from here https://rpubs.com/therimalaya/43190
diag_plot<-function(model){
  p1<-ggplot2::ggplot(model, ggplot2::aes(.fitted, .resid))+ggplot2::geom_point()
  p1<-p1+ggplot2::stat_smooth(method="loess")+ggplot2::geom_hline(yintercept=0, col="red", linetype="dashed")
  p1<-p1+ggplot2::xlab("Fitted values")+ggplot2::ylab("Residuals")
  p1<-p1+ggplot2::ggtitle("Residual vs Fitted Plot")+ggplot2::theme_minimal()

  p2<-ggplot2::ggplot(model, ggplot2::aes(qqnorm(.stdresid)[[1]], .stdresid))+
    ggplot2::geom_point(na.rm = TRUE)
  p2<-p2+
    ggplot2::xlab("Theoretical Quantiles")+ggplot2::ylab("Standardized Residuals")
  p2<-p2+ggplot2::ggtitle("Normal Q-Q")+ggplot2::theme_minimal()


  p4<-ggplot2::ggplot(model, ggplot2::aes(seq_along(.cooksd), .cooksd))+
    ggplot2::geom_bar(stat="identity", position="identity")
  p4<-p4+ggplot2::xlab("Obs. Number")+ggplot2::ylab("Cook's distance")
  p4<-p4+ggplot2::ggtitle("Cook's distance")+ggplot2::theme_minimal()

  p5<-ggplot2::ggplot(model, ggplot2::aes(.hat, .stdresid))+
    ggplot2::geom_point(ggplot2::aes(size=.cooksd), na.rm=TRUE)
  p5<-p5+ggplot2::stat_smooth(method="loess", na.rm=TRUE)
  p5<-p5+ggplot2::xlab("Leverage")+ggplot2::ylab("Standardized Residuals")
  p5<-p5+ggplot2::ggtitle("Residual vs Leverage Plot")
  p5<-p5+ggplot2::scale_size_continuous("Cook's Distance", range=c(1,5))
  p5<-p5+ggplot2::theme_minimal()+ggplot2::theme(legend.position="bottom")



  cowplot::plot_grid(p1, p2, p4, p5, nrow = 2)
}

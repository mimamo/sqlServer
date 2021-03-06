USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AP03673_Pre1]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AP03673_Pre1    Script Date: 4/7/98 12:54:32 PM ******/
--apptable
CREATE PROC [dbo].[AP03673_Pre1] @RI_ID smallint
AS

        ---  Update the apHist information

        UPDATE  AP03673_Wrk
        SET
                apHist_CpnyID       = apHist.CpnyID         ,
                apHist_FiscYr         = apHist.FiscYr         ,
                apHist_PtdCrAdjs00    = apHist.PtdCrAdjs00    ,
                apHist_PtdCrAdjs01    = apHist.PtdCrAdjs01    ,
                apHist_PtdCrAdjs02    = apHist.PtdCrAdjs02    ,
                apHist_PtdCrAdjs03    = apHist.PtdCrAdjs03    ,
                apHist_PtdCrAdjs04    = apHist.PtdCrAdjs04    ,
                apHist_PtdCrAdjs05    = apHist.PtdCrAdjs05    ,
                apHist_PtdCrAdjs06    = apHist.PtdCrAdjs06    ,
                apHist_PtdCrAdjs07    = apHist.PtdCrAdjs07    ,
                apHist_PtdCrAdjs08    = apHist.PtdCrAdjs08    ,
                apHist_PtdCrAdjs09    = apHist.PtdCrAdjs09    ,
                apHist_PtdCrAdjs10    = apHist.PtdCrAdjs10    ,
                apHist_PtdCrAdjs11    = apHist.PtdCrAdjs11    ,
                apHist_PtdCrAdjs12    = apHist.PtdCrAdjs12    ,
                apHist_PtdDiscTkn00   = apHist.PtdDiscTkn00   ,
                apHist_PtdDiscTkn01   = apHist.PtdDiscTkn01   ,
                apHist_PtdDiscTkn02   = apHist.PtdDiscTkn02   ,
                apHist_PtdDiscTkn03   = apHist.PtdDiscTkn03   ,
                apHist_PtdDiscTkn04   = apHist.PtdDiscTkn04   ,
                apHist_PtdDiscTkn05   = apHist.PtdDiscTkn05   ,
                apHist_PtdDiscTkn06   = apHist.PtdDiscTkn06   ,
                apHist_PtdDiscTkn07   = apHist.PtdDiscTkn07   ,
                apHist_PtdDiscTkn08   = apHist.PtdDiscTkn08   ,
                apHist_PtdDiscTkn09   = apHist.PtdDiscTkn09   ,
                apHist_PtdDiscTkn10   = apHist.PtdDiscTkn10   ,
                apHist_PtdDiscTkn11   = apHist.PtdDiscTkn11   ,
                apHist_PtdDiscTkn12   = apHist.PtdDiscTkn12   ,
                apHist_PtdDrAdjs00    = apHist.PtdDrAdjs00    ,
                apHist_PtdDrAdjs01    = apHist.PtdDrAdjs01    ,
                apHist_PtdDrAdjs02    = apHist.PtdDrAdjs02    ,
                apHist_PtdDrAdjs03    = apHist.PtdDrAdjs03    ,
                apHist_PtdDrAdjs04    = apHist.PtdDrAdjs04    ,
                apHist_PtdDrAdjs05    = apHist.PtdDrAdjs05    ,
                apHist_PtdDrAdjs06    = apHist.PtdDrAdjs06    ,
                apHist_PtdDrAdjs07    = apHist.PtdDrAdjs07    ,
                apHist_PtdDrAdjs08    = apHist.PtdDrAdjs08    ,
                apHist_PtdDrAdjs09    = apHist.PtdDrAdjs09    ,
                apHist_PtdDrAdjs10    = apHist.PtdDrAdjs10    ,
                apHist_PtdDrAdjs11    = apHist.PtdDrAdjs11    ,
                apHist_PtdDrAdjs12    = apHist.PtdDrAdjs12    ,
                apHist_PtdPaymt00     = apHist.PtdPaymt00     ,
                apHist_PtdPaymt01     = apHist.PtdPaymt01     ,
                apHist_PtdPaymt02     = apHist.PtdPaymt02     ,
                apHist_PtdPaymt03     = apHist.PtdPaymt03     ,
                apHist_PtdPaymt04     = apHist.PtdPaymt04     ,
                apHist_PtdPaymt05     = apHist.PtdPaymt05     ,
                apHist_PtdPaymt06     = apHist.PtdPaymt06     ,
                apHist_PtdPaymt07     = apHist.PtdPaymt07     ,
                apHist_PtdPaymt08     = apHist.PtdPaymt08     ,
                apHist_PtdPaymt09     = apHist.PtdPaymt09     ,
                apHist_PtdPaymt10     = apHist.PtdPaymt10     ,
                apHist_PtdPaymt11     = apHist.PtdPaymt11     ,
                apHist_PtdPaymt12     = apHist.PtdPaymt12     ,
                apHist_PtdPurch00     = apHist.PtdPurch00     ,
                apHist_PtdPurch01     = apHist.PtdPurch01     ,
                apHist_PtdPurch02     = apHist.PtdPurch02     ,
                apHist_PtdPurch03     = apHist.PtdPurch03     ,
                apHist_PtdPurch04     = apHist.PtdPurch04     ,
                apHist_PtdPurch05     = apHist.PtdPurch05     ,
                apHist_PtdPurch06     = apHist.PtdPurch06     ,
                apHist_PtdPurch07     = apHist.PtdPurch07     ,
                apHist_PtdPurch08     = apHist.PtdPurch08     ,
                apHist_PtdPurch09     = apHist.PtdPurch09     ,
                apHist_PtdPurch10     = apHist.PtdPurch10     ,
                apHist_PtdPurch11     = apHist.PtdPurch11     ,
                apHist_PtdPurch12     = apHist.PtdPurch12
        FROM    AP03673_Wrk LEFT OUTER JOIN apHist ON Vendor_Vendid = apHist.VendID AND apHist_FiscYr = APHist.FiscYr
                     and APHist_cpnyID = APHist.CpnyID
        WHERE   RI_ID = @RI_ID
GO

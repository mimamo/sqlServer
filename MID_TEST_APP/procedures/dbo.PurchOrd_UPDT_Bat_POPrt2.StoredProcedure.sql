USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_UPDT_Bat_POPrt2]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_UPDT_Bat_POPrt2    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc  [dbo].[PurchOrd_UPDT_Bat_POPrt2] @parm1 varchar ( 10), @parm2 varchar ( 10) as
       Update PurchOrd
           Set  PrtBatNbr      =  ''

           where PrtBatNbr     =  @parm1
             and PONbr      =  @parm2
             and Status = 'P'
GO

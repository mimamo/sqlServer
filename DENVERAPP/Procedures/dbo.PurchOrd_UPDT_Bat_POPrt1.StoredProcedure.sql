USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_UPDT_Bat_POPrt1]    Script Date: 12/21/2015 15:43:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_UPDT_Bat_POPrt1    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc  [dbo].[PurchOrd_UPDT_Bat_POPrt1] @parm1 varchar ( 10) as
       Update PurchOrd
           Set  PrtBatNbr      =  ''

           where PrtBatNbr     =  @parm1
             and Status = 'P'
GO

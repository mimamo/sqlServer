USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PayPeriod_PayGrpId_PayPerNbr]    Script Date: 12/21/2015 15:42:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PayPeriod_PayGrpId_PayPerNbr] @parm1 varchar ( 6), @parm2 smallint as
       Select * from PayPeriod
           where PayGrpId   =  @parm1
             and PayPerNbr  =  @parm2
           order by PayGrpId,
                    PayPerNbr
GO

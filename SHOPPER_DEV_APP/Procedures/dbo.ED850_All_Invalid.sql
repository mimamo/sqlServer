USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850_All_Invalid]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850_All_Invalid]
 @Parm1 varchar( 10 )
As
Select * from ED850Header Where UpdateStatus Not In ('OK','OC','H','IN','LM')
And CpnyId =  @Parm1 Order By EDIPOID
GO

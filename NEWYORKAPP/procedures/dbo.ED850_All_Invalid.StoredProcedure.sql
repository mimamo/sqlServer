USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850_All_Invalid]    Script Date: 12/21/2015 16:00:57 ******/
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

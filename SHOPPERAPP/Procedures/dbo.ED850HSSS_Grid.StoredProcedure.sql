USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HSSS_Grid]    Script Date: 12/21/2015 16:13:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850HSSS_Grid] @CpnyId varchar(10), @EDIPOID varchar(15) As
Select * From ED850HSSS Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
Order By CpnyId, EDIPOID, LineNbr
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_Nav]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Header_Nav] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select * From ED850Header Where CpnyId Like @CpnyId And EDIPOID Like @EDIPOID Order By EDIPOID
GO

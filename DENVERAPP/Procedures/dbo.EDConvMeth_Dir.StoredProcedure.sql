USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDConvMeth_Dir]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDConvMeth_Dir] @Parm1 varchar(3), @Parm2 varchar(1), @Parm3 varchar(3) As
Select * From EDConvMeth Where Trans = @Parm1 And Direction = @Parm2
And ConvCode Like @Parm3 Order By ConvCode
GO

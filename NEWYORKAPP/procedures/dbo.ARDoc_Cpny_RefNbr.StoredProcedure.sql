USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Cpny_RefNbr]    Script Date: 12/21/2015 16:00:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Cpny_RefNbr    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_Cpny_RefNbr] @parm1 varchar ( 10),@parm2 varchar ( 10) as
    Select * from ARDoc where CpnyId Like @parm1 And RefNbr like @parm2
GO

USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SlsPrcHdr_Massupdate1]    Script Date: 12/21/2015 15:55:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SlsPrcHdr_Massupdate1    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.SlsPrcHdr_Massupdate1    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[SlsPrcHdr_Massupdate1] @parm1 varchar (4) as
     Select * from SlsPrc where CuryID Like @parm1
	order by SlsPrcID
GO

USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDPPFileFormat_Descr]    Script Date: 12/21/2015 13:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDPPFileFormat_Descr]
   @FormatID	varchar(15)

AS
   SELECT       Descr
   FROM		XDDPPFileFormat (NoLock)
   WHERE	FormatID = @FormatID
GO

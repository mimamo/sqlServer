USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDLBFileFormat_Descr]    Script Date: 12/21/2015 16:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDLBFileFormat_Descr]
   @FormatID	varchar(15)

AS
   SELECT       Descr
   FROM		XDDLBFileFormat (NoLock)
   WHERE	FormatID = @FormatID
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFileFormat_Descr]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFileFormat_Descr]
   @FormatID	varchar(15)

AS
   SELECT       Descr
   FROM		XDDFileFormat (NoLock)
   WHERE	FormatID = @FormatID
GO

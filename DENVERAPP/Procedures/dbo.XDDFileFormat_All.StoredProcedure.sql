USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFileFormat_All]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFileFormat_All]
   @Selected	varchar(1),
   @FormatID	varchar(15)

AS
   SELECT * FROM XDDFileFormat WHERE Selected LIKE @Selected and FormatID LIKE @FormatID ORDER BY FormatID
GO

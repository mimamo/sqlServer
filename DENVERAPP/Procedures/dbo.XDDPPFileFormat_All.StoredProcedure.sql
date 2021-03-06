USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDPPFileFormat_All]    Script Date: 12/21/2015 15:43:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDPPFileFormat_All]
   @Selected	varchar(1),
   @FormatID	varchar(15)

AS
   SELECT       *
   FROM         XDDPPFileFormat (nolock)
   WHERE        Selected LIKE @Selected
                and FormatID LIKE @FormatID
   ORDER BY     FormatID
GO

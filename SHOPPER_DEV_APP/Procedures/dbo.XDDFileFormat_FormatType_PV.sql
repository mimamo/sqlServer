USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFileFormat_FormatType_PV]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFileFormat_FormatType_PV]
   @Selected	varchar(1),
   @FormatType	varchar(1),
   @FormatID	varchar(15)

AS
   SELECT       FormatID, Descr, FormatType		-- replaced *, SWIM record len restriction
   FROM         XDDFileFormat
   WHERE        Selected LIKE @Selected
   		and FormatType LIKE @FormatType
                and FormatID LIKE @FormatID
   ORDER BY     FormatID
GO

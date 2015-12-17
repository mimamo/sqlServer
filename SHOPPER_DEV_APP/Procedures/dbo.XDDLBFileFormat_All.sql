USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDLBFileFormat_All]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDLBFileFormat_All]
   @FormatID	varchar(15)

AS
   SELECT       *
   FROM         XDDLBFileFormat
   WHERE        FormatID LIKE @FormatID
   ORDER BY     FormatID
GO

USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTxnType_All]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTxnType_All]
   @FormatID	varchar(15),
   @EntryClass	varchar(4)

AS
   SELECT       *
   FROM		XDDTxnType
   WHERE	FormatID = @FormatID
   		and EntryClass LIKE @EntryClass
   ORDER BY	FormatID, EntryClass
GO

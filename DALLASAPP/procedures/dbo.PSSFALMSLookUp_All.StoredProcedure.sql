USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFALMSLookUp_All]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFALMSLookUp_All] @parm1 varchar(20) AS SELECT * FROM vw_PSSFALMSLookUp WHERE LoanNo LIKE  @parm1 ORDER BY LoanNo
GO

USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSTmpLLMerge_All]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSTmpLLMerge_All] @parm1 VARCHAR(20) AS
  SELECT * FROM PSSTmpLLMerge WHERE LoanNo LIKE @parm1 ORDER BY LoanNo
GO

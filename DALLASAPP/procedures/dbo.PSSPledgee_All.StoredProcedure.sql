USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSPledgee_All]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSPledgee_All]
  @parm1 VARCHAR(20)
  AS
  SELECT *
    FROM PSSPledgee 
    WHERE PledgeCode LIKE @parm1 
    ORDER BY PledgeCode
GO

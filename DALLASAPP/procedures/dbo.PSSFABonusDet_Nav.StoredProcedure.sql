USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFABonusDet_Nav]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFABonusDet_Nav] @parm1 VARCHAR(10), @parm2min SMALLINT, @parm2max SMALLINT AS
  SELECT * FROM PSSFABonusDet WHERE BonusDeprCd = @parm1 AND LineId BETWEEN @parm2min AND @parm2max ORDER BY StartDate
GO

USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smConDeposit_applied_all]    Script Date: 12/21/2015 16:13:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConDeposit_applied_all] @parm1 varchar(10) AS
          SELECT *
            FROM smConDeposit d
      INNER JOIN smConDepApplied da
              ON d.BatNbr      =    da.BatNbr
             AND d.LineNbr     =    da.LineNbr
           WHERE d.ContractID  like @parm1
             AND da.AmtApplied <>   0
        ORDER BY da.BatNbr,
                 da.LineNbr,
                 da.RecordID
GO

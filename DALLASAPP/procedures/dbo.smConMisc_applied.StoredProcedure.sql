USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smConMisc_applied]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConMisc_applied] @parm1 varchar(10) AS
          SELECT *
            FROM smConMisc
           WHERE ContractID like @parm1
             AND Status = 'I'
             AND ARBatnbr <> ''
        ORDER BY BatNbr,
                 LineNbr
GO

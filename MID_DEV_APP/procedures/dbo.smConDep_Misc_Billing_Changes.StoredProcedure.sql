USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConDep_Misc_Billing_Changes]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConDep_Misc_Billing_Changes]  @parm1 varchar(10), @parm2 varchar(1) AS
        DECLARE @Total float

        IF @parm2 = 'U'
        BEGIN
            select @Total = coalesce(sum(extprice),0)
              from smConMisc
             where ContractID = @parm1
               and status = 'A'

            select @Total = @Total - coalesce(sum(amount-amtapplied),0)
              from smConDeposit
             where ContractID = @parm1
               and status = 'A'
        END
        ELSE
        BEGIN
            select @Total = coalesce(sum(extprice),0)
              from smConMisc
             where ContractID = @parm1
               and status = 'I'

            select @Total = @Total - coalesce(sum(amtapplied),0)
              from smConDeposit
             where ContractID = @parm1
               and status = 'I'

            select @Total = @Total - coalesce(sum(amtapplied),0)
              from smConDeposit
             where ContractID = @parm1
               and status = 'A'
        END

        select @Total
GO

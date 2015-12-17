USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_UPDT_Type_EDId_DedType]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnDed_UPDT_Type_EDId_DedType] @parm1 varchar ( 1), @parm2 varchar ( 10), @parm3 varchar ( 1), @parm4 varchar ( 4) as
       Update EarnDed
           Set EarnDedType = @parm3
           where EDType       =  @parm1
             and EarnDedId  =  @parm2
             and CalYr = @parm4
GO

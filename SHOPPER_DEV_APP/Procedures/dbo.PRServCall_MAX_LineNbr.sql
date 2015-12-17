USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRServCall_MAX_LineNbr]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRServCall_MAX_LineNbr] @parm1 varchar(10),@parm2 varchar(1),
                                   @parm3min smallint, @parm3max smallint,
                                   @parm4min smallint, @parm4max smallint as
       Select max(LineNbr) from smServDetail
                          where ServiceCallId = @parm1
                            and BillingType   = @parm2
                            and FlatRateLineNbr BETWEEN @parm3min AND @parm3max
                            and LineNbr BETWEEN @parm4min AND @parm4max
GO

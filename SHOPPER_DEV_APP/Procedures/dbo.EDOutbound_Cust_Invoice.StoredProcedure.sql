USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDOutbound_Cust_Invoice]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDOutbound_Cust_Invoice] @parm1 varchar(15)  AS
select * from EDOutbound where custid = @parm1 and  Trans in ('810','880')
GO

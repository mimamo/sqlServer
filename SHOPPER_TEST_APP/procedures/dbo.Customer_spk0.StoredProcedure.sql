USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Customer_spk0]    Script Date: 12/21/2015 16:06:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[Customer_spk0] @parm1 varchar (15)  as
select * from Customer
where CustId = @parm1
order by CustId
GO

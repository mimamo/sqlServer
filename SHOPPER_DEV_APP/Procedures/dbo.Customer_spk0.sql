USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Customer_spk0]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[Customer_spk0] @parm1 varchar (15)  as
select * from Customer
where CustId = @parm1
order by CustId
GO

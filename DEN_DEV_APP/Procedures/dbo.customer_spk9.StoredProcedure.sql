USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[customer_spk9]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[customer_spk9] @parm1 varchar (250) , @parm2 varchar (15)  as
select * from customer
where custid = @parm2
order by custid
GO

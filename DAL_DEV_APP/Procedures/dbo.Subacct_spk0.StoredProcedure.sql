USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Subacct_spk0]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[Subacct_spk0] @parm1 varchar (24)  as
select * from Subacct
where Sub = @parm1
order by Sub
GO

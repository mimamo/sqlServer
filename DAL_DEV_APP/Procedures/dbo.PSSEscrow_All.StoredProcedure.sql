USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSEscrow_All]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSEscrow_All] @parm1 varchar(10) As 
	select * from PSSEscrow
	where AcctId like @parm1
	order by AcctId
GO

USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTRAN_uus1]    Script Date: 12/21/2015 14:05:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[APTRAN_uus1]
as
update APTRAN
set extrefnbr = aptran.user2,
user2 = ' ',
user3 = 0
where APTRAN.user3 = -8888.00
GO

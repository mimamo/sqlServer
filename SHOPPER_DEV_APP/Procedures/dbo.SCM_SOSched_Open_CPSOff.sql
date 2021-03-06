USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_SOSched_Open_CPSOff]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[SCM_SOSched_Open_CPSOff]
as
	select		l.InvtID,
			s.SiteID

	from		SOSched s

	  		join	SOLine l
			on	s.CpnyID = l.CpnyID
	  		and	s.OrdNbr = l.OrdNbr
	  		and	s.LineRef = l.LineRef
	  		and 	l.Status = 'O'

	where		s.Status = 'O'

	group by	l.InvtID,
			s.SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO

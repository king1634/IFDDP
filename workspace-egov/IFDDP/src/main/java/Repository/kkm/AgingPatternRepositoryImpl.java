package Repository.kkm;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Repository
public class AgingPatternRepositoryImpl implements AgingPatternRepository {
	private final SqlSession session;
}
